require 'shopify_api'
require 'filemagic'

module Shopifydev
  class Asset
    attr_accessor :shop, :remote_key

    def initialize(shop, path=ENV['TM_FILEPATH'], project_root)
      puts "in asset::initialize"
      @shop = shop

      # Asset name should be relative to TM_PROJECT_DIRECTORY
      # but if it isn't, then gsub just doesn't replace anything
      # so if you know the key, you can just supply the key?
      unless project_root.nil?
        @remote_key = path.gsub(project_root + '/', '') # fix absolute path
        @local_path = Pathname.new(project_root + '/' + @remote_key) # prepend project root
      else
        raise Exception, "could no determine project_root. In .shopifydev.yaml include\n  project_root: relative/path"
      end
    end

    def upload(root=nil)
      # check that it's not binary 
      puts "in upload"

      puts "creating asset for " + @remote_key
      puts @remote_key
      asset = ShopifyAPI::Asset.new(:key => @remote_key)

      puts "filling with 1's and 0's from " + @local_path.to_path

      contents = File.read(@local_path.to_path)

      fm = FileMagic.new

      if (fm.file(@local_path.realpath.to_path).include?('image'))
        asset.attach contents
      else
        asset.value = contents
      end

      # TODO this doesn't fail spectacularly enough... I don't 
      # feel comfortable with that
      puts "saving..."
      if asset.valid?
        if asset.save
          puts "Success!"
        else
          puts "failed to save"
        end
      else
        puts "failed to validate"
      end
      puts "---"
    end

    def download
      response = ShopifyAPI::Asset.find(@remote_key) # get the asset
      file = Pathname.new(response.attributes["key"])

      directory_path = Pathname.new(@shop.project_root +
                                 File::Separator +
                                 file.dirname.to_path)

      directory_path.mkpath unless (directory_path.exist?)

      begin
        puts "downloading #{file.basename}"
        asset = get_asset(file.to_path)
      rescue SocketError => e
        puts e.message
        puts "The connection was interupted while downloading #{file.to_path}."
      end

      # TODO maybe this should compare timestamps?
      File.open((directory_path.realdirpath + file.basename).to_path, 'w') do |f|
        puts "writing #{directory_path.to_path + File::Separator +  file.basename.to_path}"
        f.write(asset.value)
        puts "---"
      end
    end

    def get_asset(key)
      ShopifyAPI::Asset.find(key)
    end
  end
end
