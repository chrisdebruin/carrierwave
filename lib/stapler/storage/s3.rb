module Stapler
  module Storage
    ##
    # Uploads things to Amazon S3 webservices
    #
    class S3 < Abstract
      
      def initialize(bucket, identifier)
        @bucket = bucket
        @identifier = identifier
      end
      
      ##
      # Connect to Amazon S3
      #
      def self.setup!
        require 'aws/s3'
        AWS::S3::Base.establish_connection!(
          :access_key_id     => Stapler.config[:s3][:access_key_id],
          :secret_access_key => Stapler.config[:s3][:secret_access_key]
        )
      end
      
      ##
      # @return [String] the bucket set in the config options
      # 
      def self.bucket
        Stapler.config[:s3][:bucket]
      end
      
      ##
      # @return [Symbol] the access priviliges the uploaded files should have
      #
      def self.access
        Stapler.config[:s3][:access]
      end
      
      ##
      # Store the file on S3
      #
      # @param [Stapler::Uploader] uploader an uploader object
      # @param [Stapler::SanitizedFile] file the file to store
      #
      # @return [#identifier] an object
      #
      def self.store!(uploader, file)
        AWS::S3::S3Object.store(uploader.filename, file.read, bucket, :access => access)
        self.new(bucket, uploader.filename)
      end
      
      # Do something to retrieve the file
      #
      # @param [Stapler::Uploader] uploader an uploader object
      # @param [String] identifier uniquely identifies the file
      #
      # @return [#identifier] an object
      #
      def self.retrieve!(uploader, identifier)
        self.new(bucket, identifier)
      end
      
      ##
      # Returns the filename on S3
      #
      # @return [String] path to the file
      #
      def identifier
        @identifier
      end

      ##
      # Returns the url on Amazon's S3 service
      #
      # @return [String] file's url
      #
      def url
        "http://s3.amazonaws.com/#{self.class.bucket}/#{identifier}"
      end
      
    end # S3
  end # Storage
end # Stapler