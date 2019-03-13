# frozen_string_literal: true

namespace :cho do
  namespace :bag do
    desc 'create a bag from a directory of files.  The files are expected to be in a named directory that does not have any bag structure.'
    task :create_from_path, [:path] => [:environment] do |_t, args|
      path = args.fetch(:path, nil)
      if path.nil?
        puts 'Path is a required argument!'
        puts 'Path should be a directory of files that you would like in the bag'
        puts 'If you have data in a directory with a structure:'
        puts '  thumb2_2019-03-13/thumb2'
        puts '  thumb2_2019-03-13/thumb2/thumb2_00001_01_thumb.png'
        puts '  thumb2_2019-03-13/thumb2/thumb2_00001_01_preservation.tif'
        puts 'Will result in a Bag with a structure:'
        puts '  thumb2_2019-03-13/bag-info.txt'
        puts '  thumb2_2019-03-13/bagit.txt'
        puts '  thumb2_2019-03-13/data'
        puts '  thumb2_2019-03-13/data/thumb2'
        puts '  thumb2_2019-03-13/data/thumb2/thumb2_00001_01_thumb.png'
        puts '  thumb2_2019-03-13/data/thumb2/thumb2_00001_01_preservation.tif'
        puts '  thumb2_2019-03-13/manifest-md5.txt'
        puts '  thumb2_2019-03-13/manifest-sha1.txt'
        puts '  thumb2_2019-03-13/tagmanifest-md5.txt'
        puts '  thumb2_2019-03-13/tagmanifest-sha1.txt'
        puts 'A zip file will be created at: /fake_location/thumb2_2019-03-13.zip'
        puts 'when you `run rake cho:bag:create_from_path[/fake_location/thumb2_2019-03-13]`'
        exit(1)
      end
      bag_it(path)
      zip_it(path)
    end

    def bag_it(path)
      bag = BagIt::Bag.new(path)
      directory_entry(bag, path)
      bag.manifest!
      data_dir_ds_store = File.join(path, 'data', '.DS_Store')
      File.delete(data_dir_ds_store) if File.exists?(data_dir_ds_store)
    end

    def zip_it(path)
      zipfile_name = "#{path}.zip"
      File.delete(zipfile_name) if File.exists?(zipfile_name)
      pn = Pathname.new(path)
      `cd #{pn.dirname} && zip -r #{zipfile_name} #{pn.basename}`
      puts 'Your original directory has been modified to contain a bag structure!'
      puts "Created a zipped Bag: #{zipfile_name}"
    end

    def directory_entry(bag, path, base_path = '')
      Dir.new(path).each do |file|
        file_path = File.join(path, file)
        if File.directory?(file_path)
          next if ['data', '.', '..'].include?(file)
          directory_entry(bag, file_path, File.join(base_path, file))
          FileUtils.remove_dir(file_path)
        elsif file == '.DS_Store'
          puts "Removing #{file_path}"
          File.delete(file_path)
        else
          next if ['bagit.txt', 'bag-info.txt'].include?(file)
          puts "Moving file #{file_path} to the bag"
          bag.add_file(File.join(base_path, file), file_path)
          File.delete(file_path)
        end
      end
    end
  end
end
