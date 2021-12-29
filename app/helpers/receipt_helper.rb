module ReceiptHelper
  include Pagy::Frontend

  def get_receipt_class(receipt)
    case receipt.state
    when 'rozpracovaná'
      'bg-info'
    when 'připravená'
      'bg-warning'
    when 'dokončená'
      'bg-success'
    end
  end
end
