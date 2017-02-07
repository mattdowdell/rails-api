# API Usage
The below documents the available actions of the API. All requests and responses will be in JSON format. The route for each action below only includes the path, the full URL will vary depending on whether the API is running in development or production mode. The development URL will either be `http://localhost:3000/$path` or `http://$IP:3000/$path`, with the production URL being `http://sensly.io/$path`.

## Devices
### Registering a device
Before a device can be registered, a new device id must be generated. See [Creating a new device id](#creating-a-new-device-id) for how to do this.

To register a device, send to following to `/api/devices` as a POST request:
```json
{
	"identity": "$device_id"
}
```

This action requires a user to be logged in and be a member of a group.

The response to this request if no errors occur will be:
```json
{
	"identity": "$identity",
	"token": "$token"
}
```

Note that the `token` in this case is different to a [CSRF token](#tokens) and essentially acts as the device's password. It should be used when creating a new [data entry](#creating-a-new-data-entry) and does not expire after use.

## Data
### Creating a new data entry
To create a new data entry, send the following to `/api/data` as a POST request:
```json
{
	"identity": "$device_id",
	"token": "$token",
	"sensor_type": "$sensor_type",
	"sensor_error": "$sensor_error",
	"sensor_data": "$sensor_data",
	"humidity": "$humidity",
	"pressure": "$pressure",
	"temperature": "$temperature",
	"log_time": "$time"
}
```

- `token` is not a CSRF token, and is instead the token from the response when registering the device.
- `sensor_type` is a SHA1 deigest as a hexadecimal string. It can be generated by hashing the sensor type which is one of `mq2`, `mq7`, or `mq135`.
- `log_time` is the time the reading was taken in unix time.

The response to this request if no errors occur will be:
```json
{
	"result": "success"
}
```

### Retrieving a device's data

## Staff actions
All staff API actions require the user to be logged in as a staff member.

### Users
#### Adding a user to staff
*This describes an action that is under not yet implemented.*

To make an existing user a staff member, send to following to `/api/staff/users/add` as a POST request:
```json
{
	"email": "$email",
	"token": "$token"
}
```

- `email` is the email address of the user being made a staff member.

#### Removing a user from staff
*This describes an action that is under not yet implemented.*

To remove the staff flag from a user account, send to following to `/api/staff/users/remove` as a POST request:
```json
{
	"email": "$email",
	"token": "$token"
}
```

- `email` is the email address of the user being made a staff member. Note that you cannot remove the staff flag from your own account.

### Devices
#### Creating a new device id
Before a device can be registered, a new identity for it must be generated. To do this, send a POST request to `api/staff/devices` with the following:
```json
{
	"type": "$type"
}
```

`type` is a SHA1 digest as a hexadecimal string. It can be generated by hashing the type name which is one of `main`, `hat`, `go` or `pro`.

The response to this request if no errors occur will be:
```json
{
	"identity": "$new_device_id"
}
```