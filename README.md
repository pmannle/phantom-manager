# Phantom::Manager

The architecture behind phantom-manager is:

![Phantom-Architecture](http://i39.tinypic.com/2gxnz3d.png)

phantom-manager allows you to use multiple phantom-js processes behind an Nginx
server. It will manage both presence and memory consumption of those processes
and kill them when appropriate, all this in sync with the Nginx configuration
so that all requests will get answered.

If you've got a singlepage application and you want to:
* Render full page for GoogleBot or other web crawlers.
* Render full page to be cached by your CDN.

While:

* Keeping your phantom-js processes running.
* Preventing your phantom-js processes from memory-bloat.
* Making sure all phantom-js processes are responsive.

This is a good way to achieve it.

## Installation

Add this line to your application's Gemfile:

    gem 'phantom-manager'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phantom-manager

## Usage

1. You will need Nginx which will load balance requests between the phantom-js
processes.
Its conf must include a "upstream phantomjs" directive with the corresponding
settings. For example:

```
upstream phantomjs {
  server 127.0.0.1:8002;
  server 127.0.0.1:8003;
  server 127.0.0.1:8004;
  server 127.0.0.1:8005;
}
```

2. A customized [rndr.me js](https://github.com/jed/rndr.me) file that will fit your configuration. There is an
   example rndrme.js [here](lib/utils/rndrme.js).

   The host configuration is where phantom-js requests the page from, so be
   sure to point it to your backend server.
   Also, set the readyEvent to be the event you'r raising so that phantom-js
   identify it should start rendering.

3. Create a config.yml file to set the variables for phantom-manager. There's
   an [example config](config/config.yml) with a documentation of each attribute and its meaning.

4. You're ready to run phantom-manager:
   Just run `phantom_monitor` from anywhere in your system to get the usage
   instructions for the command line tool.

   Usually, you would just `phantom_monitor -c YOUR_CONF_FILE -e YOUR_ENV`
   The env option is there to allow your config.yml to have multiple
   environments settings.

5. The phantom_monitor process listens for USR2 signals. Once such a signal is
   sent it will restart all processes one by one.

## How Does It Work?

Phantom manager will check for presence, memory consumption and responsiveness of your
phantom-js processes under the configuration you have defined.

### Presence

Assuming configuration:

```
phantom_base_port: 8002
phantom_processes_number: 3
```
The monitor will keep phantom-js processes up on ports 8002, 8003, 8004
If a phantom-js crashes the monitor will bring it back up.

### Memory Consumption

Assuming configuration:
```
memory_limit: 100_000
memory_retries: 3
memory_check_interval: 5
```
The monitor sample all phantom-js processes each 5 seconds and restart those
which their memory exceeded 100MB for 3 straight samples.

### Response Time

Assuming Configuration:

```
response_time_threshold: 2
response_time_check_retries: 2
response_time_check_interval: 40
```

The monitor will send an HTTP request to root path (/) of each phantom-js process.
If a response is not received within 2 seconds for 2 consecutive samples the
process will be restarted.


### Restarting Processes

To restart a phantom-js process the monitor performs the following actions:

1. Remove the process from nginx upstream config.

2. Reload Nginx.

3. Sleeps for phantom_termination_grace seconds to allow this phantom to
   respond to all requests in its request queue.

4. Kill the phantom-js process.

5. Start the phantom-js process on the same port.

6. Add it to the Nginx upstream configuration.

7. Reload Nginx.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
