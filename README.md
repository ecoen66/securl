# Public Spaces for Cisco Webex Teams

Installation
------------

``` bash
$ git clone https://github.com/ecoen66/securl.git
$ npm install
```

After it's installed you need to configure it.

Configuration
------------

Some environment variables must be set for this to work. You can create a .env file or set environment variables based on the details below.

If using a .env file, it must be in the same directory as index.js.

``` bash
#Specify the port for epxress to listen on [optional; default = 3000]
#PORT=3000

#Specify the port for admin apis to listen on [optional]
#PORT=3001

#If a reverse web proxy is in front of express set to "true" [optional; default = false]
#REVERSE_PROXY="true"

#This is the URL that users will visit to join spaces [required]
BASE_URL="https://<hostname>/<path>"

#The Mongo DB URI to use to store data on public spaces and sessions [required]
MONGO_URI="mongodb://localhost/publicspaces-webexteams"

#The access token for the Cisco Webex Teams bot [required]
#Note: The ciscospark package requires this env variable to be set. That package hasn't changed naming to Webex Teams yet.
CISCOSPARK_ACCESS_TOKEN="<provided by https://developer.webex.com/>"

#The Cisco Webex Teams Space ID (roomId) that will have errors posted. Required to test existance of accounts in Cisco Webex Teams [optional]
#WEBEXTEAMS_ADMIN_SPACE_ID=

#Cisco Webex Teams Webhook secret to verify authenticity of data [optional]
#WEBEXTEAMS_WEBHOOK_SECRET=

#Messages to send to Cisco Webex Teams to avoid hit ratelimiting [optional; default = 4]
#Note: Currently only used during startup to build membership cache
#WEBEXTEAMS_MESSAGES_PER_SECOND=4

#The URL to the source code repository for this bot [optional; default = https://github.com/birdietiger/publicspaces-webexteams]
#SOURCE_URL=

#The Cisco Webex Teams Space ID (roomId) that users can join to get support [optional]
#WEBEXTEAMS_SUPPORT_SPACE_ID=

#Restrict the user domains the bot will respond to and add to spaces. If set, disables "internal" setting in spaces [optional]
#PERMIT_DOMAINS=

#Set description used for website listing and messaging help [optional]
#DESCRIPTION=

#Allows users of website to request support via email [optional]
#SUPPORT_EMAIL=

#Where to store logs in machine-readable format [optional]
#LOG_FILE=

#Set log level [optional; default = info]
#"error", "warn", "info", "verbose", "debug", or "silly"
#LOG_LEVEL="debug"
```

Cisco Webex Teams Webhooks
------------

For the bot to receive all notifications from Cisco Webex Teams, you must manually create a [webhook](https://developer.webex.com/webhooks-explained.html).

Webhooks are expected at `https://<hostname>/<path>/api/webhooks`. You'll need to use the same secret for all webhooks and set it in the `WEBEXTEAMS_WEBHOOK_SECRET` environment variable.

You'll need to create the following webhooks:

``` json
{
  "name": "publicspaces messages:created",
  "targetUrl": "https://<hostname>/<path>/api/webhooks",
  "resource": "messages",
  "event": "created",
  "secret": "<WEBEXTEAMS_WEBHOOK_SECRET environment variable>"
}
```

``` json
{
  "name": "publicspaces rooms:updated",
  "targetUrl": "https://<hostname>/<path>/api/webhooks",
  "resource": "rooms",
  "event": "updated",
  "secret": "<WEBEXTEAMS_WEBHOOK_SECRET environment variable>"
}
```

``` json
{
  "name": "publicspaces memberships:all",
  "targetUrl": "https://<hostname>/<path>/api/webhooks",
  "resource": "memberships",
  "event": "all",
  "secret": "<WEBEXTEAMS_WEBHOOK_SECRET environment variable>"
}
```

Alternatively, you could create a firehose webhook.

``` json
{
  "name": "publicspaces all:all",
  "targetUrl": "https://<hostname>/<path>/api/webhooks",
  "resource": "all",
  "event": "all",
  "secret": "<WEBEXTEAMS_WEBHOOK_SECRET environment variable>"
}
```

It's probably easiest to use the Cisco Webex Teams developer [API docs](https://developer.webex.com/endpoint-webhooks-post.html).

Cisco Webex Teams Webhooks require https, so take a look at the Reverse Web Proxy section.

Reverse Web Proxy
------------

It's expected that you'll front end this app with a reverse web proxy as the app doesn't natively support https. Cisco Webex Teams Webhooks require https, so that endpoint will have to have a proxy. While you could just put a proxy in front of the webhook endpoint, its recommend that all endpoints are served over https.
