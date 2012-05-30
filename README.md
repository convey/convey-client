# Convey Client

The convey_client gem is an API client for convey.io

## Installation

    gem install convey_client

## Configuration

Add the below to a file and require it at boot up:

    ConveyClient.setup do |config|
      config.subdomain = "convey"
      config.use_cache(:basic_file, 300, :path => "tmp/")
    end

You can specify any Moneta cache store you like, e.g. basic_file, memory, memcache etc and the gem will then cache every request you perform. The (optional) second argument is cache expiry in seconds, you can provide any initialize options required by your cache store as the 3rd arg.

There is an optional third config item, config.raise_request_errors which defaults to false. If you set this to true and the client encounters errors, ConveyClient::RequestErrors will be raised, otherwise you silently get an empty result set (this will be improved in the future).

## Usage

Get a specific item

    ConveyClient::Items.find("convey-item-id")

Get all of your items from convey.io

    ConveyClient::Items.all

Get all items from a specific convey.io bucket

    ConveyClient::Items.in_bucket("convey-bucket-id")

Get all items made with a specific convey.io template

    ConveyClient::Items.in_bucket("convey-template-id")

Get all items from a specific bucket, made with the given template

    ConveyClient::Items.in_bucket_and_using_template("convey-bucket-id", "convey-template-id")

For any request returning a collection, you can search and sort (limiting coming soon), for example:

    ConveyClient::Items.all.sorted("published_on", "desc") # get all items, sorted by the published_on attribute
    ConveyClient::Items.all.where("published_on" ">", "2012-05-30") # get all items published after May 30, 2012

The available searching operators are: >, <, >=, <=, =, !=, contains, does_not_contain

