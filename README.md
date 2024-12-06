# Email JSON Extractor

A Ruby service that processes AWS SES (Simple Email Service) notifications and extracts JSON content from emails. This service provides two main functionalities:
1. AWS SES event mapping
2. JSON content extraction from emails

## 🚀 Features

### AWS SES Event Mapping (`/map`)
- Processes AWS SES event notifications
- Validates and transforms JSON structures
- Handles email processing receipts and verdicts
- Provides detailed error reporting

### Email JSON Extraction (`/parse-email`)
- Extracts JSON content from emails using multiple strategies:
  1. Email attachments
  2. URLs within email body
  3. Nested JSON URLs in HTML content
  4. Direct email body parsing
- Supports both remote URLs and local email files
- UTF-8 encoding support for international characters

## 📋 Prerequisites

- Ruby (recommended version: 2.7+)
- Bundler

## 🛠 Installation

1. Clone the repository:
git clone https://github.com/yourusername/email-json-extractor.git
cd mail-parser

2. Install dependencies:
bundle install

## 💻 Usage

### Starting the Server

ruby lib/easy.rb # For AWS SES mapping service
ruby lib/challenge.rb # For email JSON extraction service

### AWS SES Event Mapping

Send a POST request to `/map`

### Email JSON Extraction

Send a POST request to `/parse-email`