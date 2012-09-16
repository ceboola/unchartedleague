module OffersHelper
  def offers_count(user)
    if user and Offer.received_offers_count(user) > 0
      " (#{Offer.received_offers_count(user)})"
    else
      ""
    end
  end
end
