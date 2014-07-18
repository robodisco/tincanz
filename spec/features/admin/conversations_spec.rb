describe 'admin::conversations', type: :feature do
  
  let(:admin){ create(:admin) }

  before do
    sign_in admin
  end
  
  it 'lists all conversations' do
    conv_a = create(:conversation)
    conv_b = create(:conversation)

    visit tincanz.admin_conversations_path
    
    conversations = Nokogiri::HTML(page.body).css(".conversations-list .subject").map(&:text)
    expect(conversations.size).to eq 2
  end

  it 'displays conversation' do
    conv = create(:conversation)
    message_a = create(:message, content: 'fiz', conversation: conv, created_at: 1.days.ago)
    message_b = create(:message, content: 'buz', conversation: conv, created_at: 10.days.ago)

    visit tincanz.admin_conversation_path(conv)

    assert_seen(conv.subject)

    messages = Nokogiri::HTML(page.body).css(".messages-list .content").map(&:text).map(&:strip)
    expect(messages).to eq [message_a.content, message_b.content]
  end

  context "creating a reply" do
    it 'is valid with content' do
      conv = create(:conversation)

      visit tincanz.admin_conversation_path(conv)

      within('.conversation-reply') do
        fill_in 'Content', with: 'coming atcha!'
        click_button 'Reply'
      end

      flash_notice!('Your reply was delivered.')
      assert_seen 'coming atcha!', within: :first_message
    end

    it "is invalid with no content" do
      conv = create(:conversation)

      visit tincanz.admin_conversation_path(conv)

      within('.conversation-reply') do
        click_button 'Reply'
      end

      flash_alert!('Could not create your reply.')
      expect(page).to_not have_content 'coming atcha!'
    end
  end
end