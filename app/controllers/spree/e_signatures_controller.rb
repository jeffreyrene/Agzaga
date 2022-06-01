module Spree
  class ESignaturesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:callbacks]
    before_action :load_chapter, only: [:new]

    def new
      signature_id = @ffa_chapter.signature_request_id
      if signature_id.present?
        url = HelloSign.get_embedded_sign_url(signature_id: signature_id)
        @signature_request_url = url.sign_url
      else
        signature_url
      end
    end

    def callbacks
      json = JSON.parse(params[:json]) if params[:json]

      if json["event"]["event_type"] == "signature_request_signed"
        ffa_chapter = FfaChapter.find_by(signature_request_id: json["signature_request"]["signatures"][0]["signature_id"])
        ffa_chapter.update_column(:is_signed, json["signature_request"]["signatures"][0]["status_code"] == 'signed') if ffa_chapter.present?
      end

      render json: 'Hello API Event Received', status: 200
    end

    private

    def signature_url
      request = HelloSign.create_embedded_signature_request_with_template(
                test_mode: ENV['HELLOSIGN_TEST_MODE'].to_i,
                template_id: ENV['HELLOSIGN_FFA_CHAPTER_TEMPLATE_ID'],
                title: 'Co-Venture Agreement',
                subject: 'Co-Venture Agreement',
                message: 'Due to regulations of your state, residents must sign a written agreement to participate in this fundraiser.',
                signers: [
                  {
                    email_address: @ffa_chapter.email,
                    name: @ffa_chapter.full_name,
                    role: 'FFA Chapter Advisor'
                  }
                ]
              )

      signature_id = request.signatures[0].signature_id

      if signature_id.present?
        @ffa_chapter.update_column(:signature_request_id, signature_id)
        url = HelloSign.get_embedded_sign_url(signature_id: signature_id)
        @signature_request_url = url.sign_url
      end
    end

    def load_chapter
      @ffa_chapter = FfaChapter.find(params.dig(:ffa_chapter_id))
    end
  end
end

# touched on 2025-05-22T22:32:39.214323Z
# touched on 2025-05-22T22:38:27.421056Z
