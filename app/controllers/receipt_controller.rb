# frozen_string_literal: true

require 'csv'
require 'date'

CSV_HEADERS = {
  number: 'Číslo',
  created_month: 'Období',
  supplier_id: 'Dodavatel',
  issued_at: 'Vystaveno',
  supplier_name: 'Název dodavatele',
  sent_at: 'Odesláno',
  planned_delivery: 'Plánované dodání',
  actual_delivery: 'Skutečné dodání',
  user: 'Uživatel',
  note: 'Poznámka',
  state: 'Stav',
  price_without_vat: 'Celkem bez DPH',
  price_with_vat: 'Celkem s DPH'
}.freeze

CSV::HeaderConverters[:map_to_main] = lambda do |header|
  if CSV_HEADERS.key(header).nil?
    header.downcase.to_sym
  else
    CSV_HEADERS.key(header)
  end
end

CSV::HeaderConverters[:map_to_header] = lambda do |header|
  CSV_HEADERS.key(header)
end

# This controller handles the receipt management (create, edit, delete and list)
class ReceiptController < ApplicationController
  def edit
    @receipt = Receipt.find(params[:id])
  end

  # This method must be implemented by the application.
  # It must return the starting and ending local Time objects array defining the calendar :period
  def pagy_calendar_period(collection)
    return [DateTime.now.getlocal, DateTime.now.getlocal] if collection.empty?

    collection.map(&:actual_delivery).minmax.map(&:getlocal)
  end

  # This method must be implemented by the application.
  # It receives the main collection and must return a filtered version of it.
  # The filter logic must be equivalent to {storage_time >= from && storage_time < to}
  def pagy_calendar_filter(collection, from, to)
    collection.where('actual_delivery BETWEEN ? AND ?', from.utc, to.utc) # storage in UTC
  end

  def calendar
    @calendar, @pagy, @records = pagy_calendar(Receipt.all, year: { size: [1, 1, 1, 1] },
                                                            month: { size: [0, 12, 12, 0], format: '%b' },
                                                            day: { size: [0, 31, 31, 0], format: '%d' },
                                                            pagy: { items: 10 },
                                                            active: !params[:skip])
  end

  # rubocop:disable Metrics/MethodLength
  def update
    @receipt = Receipt.find(params[:id])
    if @receipt.update(params.require(:receipt).permit(
                         :number,
                         :created_month,
                         :issued_at,
                         :supplier_name,
                         :sent_at,
                         :planned_delivery,
                         :actual_delivery,
                         :user,
                         :note,
                         :state
                       ))
      redirect_to action: 'list'
    else
      edit_receipt_path(receipt)
    end
  end
  # rubocop:enable Metrics/MethodLength

  # https://youtu.be/waEC-8GFTP4?t=27
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
  def list
    result = Receipt.all
    result = result.where('number LIKE ?', "%#{params[:number]}%") if params[:number].present?
    result = result.where(issued_at: params[:issued_at]) if params[:issued_at].present?
    result = result.where(sent_at: params[:sent_at]) if params[:sent_at].present?
    result = result.where(planned_delivery: params[:planned_delivery]) if params[:planned_delivery].present?
    result = result.where(actual_delivery: params[:actual_delivery]) if params[:actual_delivery].present?
    result = result.where(state: params[:state]) if params[:state].present?
    result = result.where('supplier_name LIKE ?', "%#{params[:supplier_name]}%") if params[:supplier_name].present?
    result = result.where('user LIKE ?', "%#{params[:user]}%") if params[:user].present?
    result = result.where('note LIKE ?', "%#{params[:note]}%") if params[:note].present?
    @pagy, @receipts = pagy(result)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength

  def import
    CSV.foreach(params[:file].path, headers: true, header_converters: :map_to_main, col_sep: ';') do |row|
      hashed_row = row.to_hash
      hashed_row[:created_month] = Date.strptime(hashed_row[:created_month], '%Y.%m')
      Receipt.create!(hashed_row)
    end
    redirect_to receipt_calendar_url
  end

  def export
    send_data(generate_csv, filename: 'receipts.csv', format: 'csv')
  end

  private

  def generate_csv
    CSV.generate(headers: true, header_converters: :map_to_header, col_sep: ';') do |csv|
      csv << CSV_HEADERS.values
      Receipt.all.each do |receipt|
        csv << CSV_HEADERS.keys.map { |key| receipt.send(key) }
      end
    end
  end
end
