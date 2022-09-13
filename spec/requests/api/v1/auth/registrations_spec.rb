require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "適切なパラメーターを送信した時" do
      let(:params) { attributes_for(:user) }
      it "レコードが発行される" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["data"]["id"]).to eq User.last.id
        expect(res["data"]["name"]).to eq User.last.name
        expect(res["data"]["email"]).to eq User.last.email
      end

      it "適切にheader情報が返ってくる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
      end
    end

    context "nameが存在しない時" do
      let(:params) { attributes_for(:user, name: nil) }

      it "レコードが発行されない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "error"
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "emailが存在しない時" do
      let(:params) { attributes_for(:user, email: nil) }

      it "レコードが発行されない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "error"
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["email"]).to eq ["can't be blank"]
      end
    end

    context "password が存在しない時" do
      let(:params) { attributes_for(:user, password: nil) }

      it "レコードが発行されない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "error"
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["password"]).to include "can't be blank"
      end
    end
  end
end
