# frozen_string_literal: true

namespace :cho do
  desc 'Creates a collection with many works'
  task :collection_test, [:length] => [:environment] do |_t, args|
    length = args.fetch(:length, 10).to_i
    collection = Collection.new
    collection.title = ['Collection of Empty Works']
    collection.description = ['Contains all the empty works used in the test']
    collection.keyword = ['collection-test']
    collection.apply_depositor_metadata('chouser@example.com')
    collection.visibility = 'open'
    collection.save

    report_file = File.open('public/collection_test.csv', 'w')
    report_file.write("count,time\n")
    (1..length).each do |count|
      i = Image.new
      i.title = ["Collection Test Work #{count}"]
      i.description = ['Empty work used for testing collections with many works']
      i.keyword = ['collection-test']
      i.apply_depositor_metadata('chouser@example.com')
      i.visibility = 'open'
      benchmark(report_file, count) do
        i.member_of_collections = [collection]
        i.save
      end
    end
    report_file.close
  end

  def benchmark(file, count)
    start = Time.now
    yield
    file.write("#{count},#{(Time.now - start)}\n")
  end
end
