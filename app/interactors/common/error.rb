module Error
  class Unknown < Citrine::Operation::Result
    message "Unknow Error! Please check third party error code"
  end

  class InvalidAmount < Citrine::Operation::Result
    message "Amount is invalid, must greater than 0"
  end

  class AmountNotEnough < Citrine::Operation::Result
    message "Amount not enough."
  end

  class BeingProcessing < Citrine::Operation::Result
    message "Being processing"
  end

  class AlreadyProcessed < Citrine::Operation::Result
    message "Already processed"
  end

  class AlreadyRejected < Citrine::Operation::Result
    message "Already rejected"
  end

  class DuplicateTrans < Citrine::Operation::Result
    message "Duplicate ref_trans_id"
  end

  class SystemBusy < Citrine::Operation::Result
    message "System busy. please try again"
  end

  class InvalidProductLine < Citrine::Operation::Result
    message "Invalid product line, cannot find instrument id"
  end

  class TokenCreateFail < Citrine::Operation::Result
    message "Token cannot be created."
  end

  class PlayerSessionCreateFail < Citrine::Operation::Result
    message "Player session cannot be created."
  end

  class PlayerSessionLockFail < Citrine::Operation::Result
    message "Player session lock fail."
  end

  class PlayerGameSessionCreateFail < Citrine::Operation::Result
    message "Player game session cannot be created."
  end

  class PlayerGameSessionLockFail < Citrine::Operation::Result
    message "Player game session lock fail."
  end

  class InvalidPlayerToken < Citrine::Operation::Result
    message "Invalid Player Token, cannot decode"
  end

  class PlayerSessionNotFound < Citrine::Operation::Result
    message "Player session not found."
  end

  class PlayerGameSessionNotFound < Citrine::Operation::Result
    message "Player game session not found."
  end

  class OpenGameSessionRejected < Citrine::Operation::Result
    message "The player game session is already closed or closing. Reject opening."
  end

  class AlreadyOpened < Citrine::Operation::Result
    message "The player game session is already opened."
  end

  class AlreadyClosed < Citrine::Operation::Result
    message "The player game session is already closed."
  end

  class FundOutFailed < Citrine::Operation::Result
    message "Fund out remained balance Failed."
  end

  class ClosePlayerGameSessionFailed < Citrine::Operation::Result
    message "Close player game session failed."
  end

  class UpdatePlayerGameSessionFailed < Citrine::Operation::Result
    message "Update player game session state to closing Failed."
  end

  class AlreadyCancelled < Citrine::Operation::Result
    message "Already cancelled."
  end

  class TotalBetAmtNotMatched < Citrine::Operation::Result
    message "Total bet amount not matched."
  end

  class TotalWinAmtNotMatched < Citrine::Operation::Result
    message "Total win amount not matched."
  end

  class BetTransactionNotFound < Citrine::Operation::Result
    message "Bet transaction not found."
  end

  class InvalidLicensee < Citrine::Operation::Result
    message "Providing licensee not in our system."
  end

  class NotImplementedError < Citrine::Operation::Result
    message "This is an abstract method."
  end

  def parse_general_error_code(response)
    case response.code
    when "DuplicateTransWithSameValue", "AlreadyProcessed"
      "completed"
    when "ServiceUnavailable", "SystemBusy", "GameSiteStop"
      "pending"
    when "InvalidLoginName", "InvalidCredit", "AmountNotEnough"
      "rejected"
    when "DuplicateTransWithoutSameValue", "DuplicateTrans", "InvalidTransDate", "InvalidTransID", "Unknown"
      "unexpected"
    else
      nil
    end
  end

  def parse_bet_error_code(response)
    case response.code
    when "AlreadyCancelled", "InvalidSessionToken"
      "rejected"
    else
      nil
    end
  end

  def parse_cancel_bet_error_code(response)
    case response.code
    when 'CancelBetNotExist'
      "completed"
    when 'CancelBetNotMatch'
      "unexpected"
    else
      nil
    end
  end

  def parse_result_error_code(response)
    case response.code
    when "InvalidBetTransaction"
      "unexpected"
    else
      nil
    end
  end
end
