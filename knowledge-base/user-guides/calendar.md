# Calendar (beta)

Calendar provides online booking, diary scheduling and appointment requests for canine rehabilitation practices.

/// note | Beta
Calendar is currently in beta. Owners and admins can turn beta access on or off in [Organisation settings](organisation-settings-and-export.md#beta-access).
///

## Calendar navigation

When beta access is enabled, the main navigation includes **Calendar** (`/booking`), structured into three tabs:

- **Schedule**: your calendar diary and list of appointments.
- **Requests**: client booking requests awaiting practitioner review.
- **Settings**: booking page configuration, services, working hours, booking rules, and payments.

## Schedule and diary

The **Schedule** tab displays your appointments and diary availability.

### Calendar views

Switch views using the view buttons in the calendar header:

- **Week**: 7-day view of appointments and availability blocks.
- **Day**: single-day detailed schedule.
- **Agenda**: chronological list of upcoming appointments.

Use **Previous**, **Today** and **Next** to navigate dates.

### Block time in your diary

Practitioners can block time in their diary with a note (for example, lunch, cleaning, or personal time). Public booking, client reschedules and approved moves will not offer that time.

1. Select **Block time** from the calendar header (or click an empty slot and choose **Block time**).
2. Enter the **Date**, **Start time** and **End time**.
3. Enter a **Note** (for example, "Lunch"). Your colleagues can see this note, but health details should not be included.
4. Select **Save**.

To edit or remove a block, select the blocked slot on the calendar, update the details or choose **Remove block**.

### Appointment details

Selecting an appointment opens a drawer with appointment details, linked client and dog information, and payment status.

## Booking requests

When dog owners request an appointment through your public booking page, their
request appears under **Requests**. Pending requests also appear in the
header **Notifications** tray, and selecting one opens it for review.

**Requests** has two tabs, which filter both the list and the calendar:

- **Pending**: requests waiting for you to confirm or decline.
- **Reviewed**: requests you have confirmed or declined. A reviewed request
  shows its appointment's payment status.

On a phone, each request is a compact row that opens in a sheet.

### Review a booking request

1. Open **Requests** from the Calendar tabs, or select the request in the
   **Notifications** tray.
2. Select a request to open the review panel.
3. Review the requested service, date, time and owner details.
4. Link the request to an existing record, or allow the system to create the
   client and dog:
    - **Search existing**: enter the client or dog name in **Search client or
      dog** and select the match. If the owner's email matches an existing
      client, the request opens already linked to that client, marked
      **Matched by email**. If several clients share the email, you choose
      between them.
    - **New client and dog**: check the details prefilled from the owner's
      request.
5. If payment is enabled, decide whether to request online payment when
   confirming.
6. Select **Confirm and book** to accept the request, or **Decline request**
   if you cannot accommodate it. Before declining, you are asked to confirm,
   with the dog's name and requested time shown.

### Expired requests

If the requested time passes before you review a request, the request is
marked **Expired** and leaves the **Pending** tab. The dog owner is not
emailed. If the request was to move an existing appointment, that appointment
stays as it was.

### Correct an owner's email address

If an owner entered a wrong email address during booking:

1. Open the request or appointment review panel.
2. Update the email under **Email**.
3. Save the change. The old management links are invalidated, and booking
   confirmation emails are resent to the corrected address.

## Calendar settings

Configure your booking experience under **Settings** in Calendar:

### Booking page

Configure your public booking page under **Settings → Booking page**:

- **Booking page state**: choose **On** (dog owners can request appointments), **Paused** (shows your paused message instead of the form), or **Off**.
- **Booking page address**: customise your organisation's booking link slug.
- **QR code**: download a QR code PNG for print materials or client sharing.
- **Preview**: select **Preview booking page** to test the booking flow as dog owners see it.

### Services

Define the services clients can book under **Settings → Services**:

1. Select **Add service**.
2. Enter the **Name** and optional **Description**.
3. Set **Duration (minutes)**.
4. Set optional **Price (£)**.
5. Set **Buffer time after appointment** (in minutes) for notes, cleaning or travel between appointments.
6. Select **Save service**.

### Hours & time off

Set your regular working hours and availability exceptions under **Settings → Hours & time off**:

- **Weekly hours**: set start and end times for each day of the week you accept bookings.
- **Time off & exceptions**: add specific dates where hours differ or where you are unavailable (e.g. holidays).

### Booking rules

Control booking constraints under **Settings → Booking rules**:

- **Minimum notice**: how many hours in advance an owner must book (e.g. 24 hours).
- **Booking window**: how far into the future appointments can be scheduled (e.g. 60 days).
- **Slot interval**: the spacing of start times offered to clients (e.g. every 15 or 30 minutes).
- **Self-cancel cut-off**: the cut-off time before an appointment after which owners can no longer cancel online and must contact the practice directly.
- **Cancellation policy**: terms shown to owners before they submit a booking request.

### Payments

/// note | Test mode
Client payments through Stripe Connect are in test mode and currently limited to test organisations during the beta.
///

Under **Settings → Payments**, practice owners and admins can connect a Stripe account to take payments for bookings:

- Connect a Stripe account via Stripe-hosted onboarding.
- Choose whether priced services require online payment when requests are accepted.
- Track payment statuses across appointments: **Payment due**, **Payment processing**, **Paid**, **Not required**, **Refund due**, and **Refunded**. **Payment processing** shows while a delayed payment method, such as Bacs Direct Debit, clears.
