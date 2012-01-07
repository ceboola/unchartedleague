module OffersHelper
  def offers_count(user)
    if user and user.received_offers_count > 0
      " (#{user.received_offers_count})"
    else
      ""
    end
  end
end
