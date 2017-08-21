# frozen_string_literal: true

namespace :cho_testing do
  desc 'Run all the Fedora tests'
  task :all, [:length] => [:environment] do |_t, args|
    length = args.fetch(:length, 10).to_i
    Rake::Task['cho_testing:collections'].invoke(length)
    # Rake::Task['cho_testing:nested_collections'].invoke(length)
    Rake::Task['cho_testing:files'].invoke(length)
  end

  desc 'Creates a collection with many empty works'
  task :collections, [:length] => [:environment] do |_t, args|
    length = args.fetch(:length, 10).to_i
    collection = Collection.new
    collection.title = ['Collection of Empty Works']
    collection.description = ['Contains all the empty works used in the test']
    collection.keyword = ['collection-test']
    collection.apply_depositor_metadata('chouser@example.com')
    collection.visibility = 'open'
    collection.save

    $stdout = File.new("tmp/cho_collections_#{length}.csv", 'w')
    $stdout.sync = true

    Benchmark.benchmark("User,System,Total,Real\n", 0, "%u,%y,%t,%r\n") do |bench|
      (1..length).each do |count|
        i = Image.new
        i.title = ["Collection Test Work #{count}"]
        i.description = ['Empty work used for testing collections with many works']
        i.keyword = ['collection-test']
        i.apply_depositor_metadata('chouser@example.com')
        i.visibility = 'open'
        bench.report do
          i.member_of_collections = [collection]
          i.save
        end
      end
    end
  end

  desc 'Creates many works with a file'
  task :files, [:length] => [:environment] do |_t, args|
    length = args.fetch(:length, 10).to_i
    FileUtils.rm_f('tmp/small_random.bin')
    FileUtils.cp('spec/fixtures/small_random.bin', 'tmp')

    user = User.find_by(email: 'chouser@example.com')

    $stdout = File.new("tmp/cho_files_#{length}.csv", 'w')
    $stdout.sync = true

    Benchmark.benchmark("User,System,Total,Real\n", 0, "%u,%y,%t,%r\n") do |bench|
      (1..length).each do |count|
        randomize_file
        bench.report do
          image = create_image(count)
          permissions = image.permissions.map(&:to_hash)
          file_set = FileSet.new
          actor = Hyrax::Actors::FileSetActor.new(file_set, user)
          actor.create_metadata(visibility: 'open')
          file_set.title = ["Small File #{count}"]
          file_set.label = "Small File #{count}"
          file_set.save
          Hydra::Works::AddFileToFileSet.call(file_set, File.open('tmp/small_random.bin', 'r'), :original_file)
          actor.attach_to_work(image)
          actor.file_set.permissions_attributes = permissions
          image.save
        end
      end
    end
  end

  def create_image(count)
    image = Image.new
    image.title = ["Small Work #{count}"]
    image.description = ['A small work containing one 1 MB file']
    image.keyword = ['works-test']
    image.visibility = 'open'
    image.apply_depositor_metadata('chouser@example.com')
    image.save
    image
  end

  def randomize_file
    File.open('tmp/small_random.bin', 'a') do |file|
      file.truncate((file.size - 36))
      file.syswrite(SecureRandom.uuid)
    end
  end
end
