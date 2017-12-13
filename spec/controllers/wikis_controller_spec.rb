require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:my_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false) }
  let(:my_user) { User.create!(email: "my_user@bloccipedia.com", password: "my_user_password") }

  describe "GET #index" do
    it "assigns [my_wiki] to @wikis" do
      get :index
      expect(assigns(:wikis)).to eq([my_wiki])
    end
  end

  describe "GET new" do
    it "instantiates @wiki" do
      sign_in my_user
      get :new
      expect(assigns(:wiki)).not_to be_nil
    end
  end

  describe "POST create" do
    before do 
      sign_in my_user
      post :create, params: { wiki: { title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false } }
    end

    it "increases the number of Wiki by 1" do
      expect(Wiki.count).to eq 1 
    end

    it "assigns the new wiki to @wiki" do
      expect(assigns(:wiki)).to eq Wiki.last
    end

    it "redirects to the new wiki" do
      expect(response).to redirect_to Wiki.last
    end
  end

  describe "GET show" do
    it "assigns my_wiki to @wiki" do
      sign_in my_user
      get :show, params: { id: my_wiki.id }
      expect(assigns(:wiki)).to eq(my_wiki)
    end
  end

  describe "GET edit" do
    it "assigns wiki to be updated to @wiki" do
      sign_in my_user
      get :edit, params: { id: my_wiki.id }

      wiki_instance = assigns(:wiki)

      expect(wiki_instance.id).to eq my_wiki.id
      expect(wiki_instance.title).to eq my_wiki.title
      expect(wiki_instance.body).to eq my_wiki.body
    end
  end

  describe "PUT update" do
    before do 
      sign_in my_user
    end

    it "updates wiki with expected attributes" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, params: { id: my_wiki.id, wiki: {title: new_title, body: new_body } }

      updated_wiki= assigns(:wiki)
      expect(updated_wiki.id).to eq my_wiki.id
      expect(updated_wiki.title).to eq new_title
      expect(updated_wiki.body).to eq new_body
    end

    it "redirects to the updated post" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, params: { id: my_wiki.id, wiki: {title: new_title, body: new_body } }
      expect(response).to redirect_to my_wiki
    end
  end

  describe "DELETE destroy" do
    before do 
      sign_in my_user
      delete :destroy, params: { id: my_wiki.id }
    end

    it "deletes the wiki" do
      count = Wiki.where({id: my_wiki.id}).size
      expect(count).to eq 0
    end

    it "redirects to wiki index" do
      expect(response).to redirect_to wikis_path
    end
  end
end
