
# Email JSON Extractor

A Ruby service that processes AWS SES (Simple Email Service) notifications by validating, transforming, and analyzing JSON event structures.  

---

## 🚀 Features

### AWS SES Event Mapping (`/map`)
- **SES Event Processing**: Parses AWS SES notifications, including email receipt, bounce, complaint, and delivery events.  
- **JSON Validation**: Ensures that SES event JSON structures meet required specifications.  
- **Transformation**: Normalizes event data into a developer-friendly format.  
- **Error Handling**: Provides detailed error reporting for invalid payloads or missing data fields.  

---

## 📋 Prerequisites

- **Ruby**: Recommended version 2.7+.
- **Bundler**: For managing Ruby gem dependencies.  

---

## 🛠 Installation

### Step 1: Clone the Repository
```bash
git clone https://github.com/daniel130300/mail-parser.git
cd mail-parser
```

### Step 2: Install Dependencies
```bash
bundle install
```

---

## 💻 Usage

### Starting the Server
Run the following command to start the service:
```bash
ruby lib/app.rb
```

### Sending Requests to `/map`
Send a **POST** request to the `/map` endpoint with an AWS SES event JSON payload.

#### Example Request:
```json
{
  "notificationType": "Bounce",
  "bounce": {
    "bounceType": "Permanent",
    "bounceSubType": "General",
    "bouncedRecipients": [
      {
        "emailAddress": "user@example.com",
        "action": "failed",
        "status": "5.1.1",
        "diagnosticCode": "smtp; 550 5.1.1 user unknown"
      }
    ],
    "timestamp": "2024-12-06T12:00:00Z",
    "feedbackId": "feedback-id-example"
  },
  "mail": {
    "timestamp": "2024-12-06T11:59:00Z",
    "source": "sender@example.com",
    "destination": ["recipient@example.com"]
  }
}
```

#### Example Response:
```json
{
  "spam": true,
  "virus": true,
  "dns": true,
  "mes": "September",
  "retrasado": false,
  "emisor": "61967230-7A45-4A9D-BEC9-87CBCF2211C9",
  "receptor": [
    "recipient"
  ]
}
```