# Create and configure Beszel stack

We will configure the Beszel Docker stack and bring the stack up through Arcane. The stack consists of the following container:

- Beszel: System monitor dashboard.
- Beszel Agent: Agent program that collects system metrics and sends them to the dashboard.

## Steps

1. Run: `./scripts/create_beszel_folder.sh` to generate the container directory on the SSD.
2. Edit the stack file: `nano ./files/beszel-stack.yml`.
3. Replace `TZ=America/New_York` with your system time zone. You can use this list as a reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
4. Replace `APP_URL` and `HUB_URL` environment variables with your registered subdomain in DuckDNS.org. If you are not exposing the service to the internet, you can use your server hostname.
5. If you have an Nvidia GPU, skip this step. Delete or comment out the uncommented image under beszel-agent `henrygd/beszel-agent-nvidia:latest` and then uncomment the commented image `henrygd/beszel-agent:alpine`. Delete or comment out the entire `runtime` and `deploy` properties.
6. Under `devices`, add all the disks you want to monitor with a one to one mapping, for example `/dev/sda:/dev/sda`.
7. Copy all contents of the file to the clipboard. Save and exit with `Ctrl + X, Y, Enter`.
8. Add stack in Arcane from the browser.
    1. Access Arcane through https://arcane.myhome.duckdns.org.
    2. Click "Projects" on the left menu and create a new project.
    3. Name it "beszel" and paste the content of the beszel-stack.yml that you copied to the clipboard and create the stack. From now on, modifications to the stack must be made through Arcane and not in the file.
9. Access Beszel through https://beszel.myhome.duckdns.org.
10. Use the wizard to create a user account and password. It is again recommended to use Bitwarden for the same.
11. Click "Add System", a dialog should appear with a `Key` and a `Token` fields. Copy them and go back to Arcane and edit the Beszel stack. Replace the `TOKEN` and `KEY` environment variables with the values you copied from the dialog and click "Save and redeploy".
12. Return to the Beszel tab in your browser and enter `localhost` under "Name" and `/beszel_socket/beszel.sock` under "Host/IP". Click `Add system` button in the dialog.
13. Go to `Settings > Notifications` and under "Webhook / Push notifications" enter `gotify://gotify.myhome.duckdns.org/{token}`. Replace `{token}` with the token you copied from Gotify for Beszel. Click the `Test URL` button to verify it works.
14. Click `Save Settings`.
15. Go back to the Beszel home page. Under "All System" `localhost` should appear. At the end of the row, click the "Alerts" button.
16. Enable and configure the alerts you wish to receive a notification for.
