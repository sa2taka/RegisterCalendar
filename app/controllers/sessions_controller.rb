class SessionsController < ApplicationController
  require 'openssl'

  PASS_DIGEST = "774fcded1e8ae0bf66bc0bbb9dab74dc1da6387c414b3d64a0cfeebb0d346737"
  PASS_DIGEST.freeze

  def new
  end

  def create
    pass = params[:session][:passcode]
    digest = OpenSSL::Digest.new('sha256')
    digest.update(pass)

    if params[:session][:id] == "sat" && digest.to_s == PASS_DIGEST
      login
      redirect_to events_url
    else
      flash.now[:danger] = "idかパスコードが間違っています"
      render 'new'
    end
  end

  def destroy
  end

end
