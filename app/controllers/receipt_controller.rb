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

# This controller handles the receipt management (create, edit, delete and list)
class ReceiptController < ApplicationController
  def calendar; end

  def new; end

  def edit; end

  def list; end

  def import
    CSV.foreach(params[:file].path, headers: true, header_converters: :map_to_main, col_sep: ';') do |row|
      hashed_row = row.to_hash
      hashed_row[:created_month] = Date.strptime(hashed_row[:created_month], '%Y.%m')
      Receipt.create!(hashed_row)
    end
    redirect_to receipt_calendar_url
  end
end
