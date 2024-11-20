namespace :update_documents_slug do
  task save_documents: :environment do
    Document.find_each(&:save)
  end
end
