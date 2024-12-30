# frozen_string_literal: true

require "rails_helper"

RSpec.describe TurboModalComponent, type: :component do
  subject { described_class.new }
  it "renders the close button with the correct data-action" do
    result = render_inline(described_class.new)

    expect(result.to_html).to include('data-action="turbo-modal#hideModal"')
    expect(result.to_html).to include('×')
  end
end
