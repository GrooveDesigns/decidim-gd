namespace :migrate_mygroove do
  desc 'mygrooveへの移行データをs3にアップロードするタスク'
  task :upload_csv => :environment do
    access_key = ENV['AWS_S3_ACCESS_KEY_ID']
    secret_key = ENV['AWS_S3_SECRET_ACCESS_KEY']
    bucket_name = ENV['AWS_S3_MIGRATE_BUCKET_NAME']
    source_path = Rails.root.join('csv') # Specify the local path of the files
    destination_path = 'csv' # Specify the S3 path to upload to
    s3_client = Aws::S3::Client.new(
      access_key_id: access_key,
      secret_access_key: secret_key,
      region: 'ap-northeast-1'
    )

    Dir.glob(File.join(source_path, '*.csv')).each do |file_path|
      file_name = File.basename(file_path)
      s3_object_key = File.join(destination_path, file_name)

      File.open(file_path, 'rb') do |file|
        s3_client.put_object(
          bucket: bucket_name,
          key: s3_object_key,
          body: file
        )
      end

      puts "Uploaded #{file_name} to S3 bucket #{bucket_name} at #{s3_object_key}"
    end
  end
end