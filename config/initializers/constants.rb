PACKAGE_PRICES = {
  "10_credits" => { unit: 10, amount: 300000 },
  "25_credits" => { unit: 25, amount: 400000 },
  "50_credits" => { unit: 50, amount: 500000 }
}.freeze

ABUSE_REASONS = {
  spam: {
    heading: "Spam",
    content: "Unsolicited or repetitive content intended to advertise, mislead, or disrupt."
  },
  fraud_or_scam: {
    heading: "Fraud or Scam",
    content: "Deceptive activity intended to steal money, information, or personal data."
  },
  harassment: {
    heading: "Harassment",
    content: "Targeted abusive behavior, threats, or repeated unwanted contact."
  },
  hate_speech: {
    heading: "Hate Speech",
    content: "Content that attacks or discriminates against individuals or groups."
  },
  impersonation: {
    heading: "Impersonation",
    content: "Pretending to be another person or organization to deceive others."
  },
  inappropriate_content: {
    heading: "Inappropriate Content",
    content: "Sexually explicit, violent, or otherwise disallowed content."
  },
  misinformation: {
    heading: "Misinformation",
    content: "False or misleading information presented as factual."
  },
  illegal_activity: {
    heading: "Illegal Activity",
    content: "Content promoting or engaging in unlawful actions."
  }
}.freeze
