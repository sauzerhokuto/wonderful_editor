require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    let(:current_user) { create(:user) }

    context "適切なメールアドレス、パスワードを送信した時" do
      let(:params) { { email: current_user.email, password: current_user.password } }

      it "ログインできる" do
        subject
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        header = response.headers
        expect(res["data"]["id"]).to eq current_user.id
        expect(res["data"]["email"]).to eq current_user.email
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
      end
    end

    context "不適切なメールアドレスを送信した時" do
      let(:params) { { email: "1234a@email.com", password: current_user.password } }
      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
        header = response.headers
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["expiry"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(header["token-type"]).to be_blank
      end
    end

    context "不適切なパスワードを送信した時" do
      let(:params) { { email: "abcd123@sample.com", password: "ab123kdi" } }
      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
        header = response.headers
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["expiry"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(header["token-type"]).to be_blank
      end
    end
  end
end
