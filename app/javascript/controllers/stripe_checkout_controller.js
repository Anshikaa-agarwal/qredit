import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { publishableKey: String, url: String }

  async connect() {
    this.stripe = Stripe(this.publishableKeyValue)
  }

  async startCheckout(event) {
    const packageKey = event.currentTarget.dataset.package
  
    const response = await fetch(this.urlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ package: packageKey })
    })
  
    const { clientSecret } = await response.json()
  
    const checkout = await this.stripe.initEmbeddedCheckout({
      clientSecret
    })
  
    const container = document.getElementById("checkout-container")
  
    // Make absolutely sure it's empty
    container.innerHTML = ""
  
    checkout.mount(container)
  }
  
}


