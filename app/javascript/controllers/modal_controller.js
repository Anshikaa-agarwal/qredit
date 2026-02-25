import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open(event) {
    const id = event.currentTarget.dataset.modalId
    const modal = document.getElementById(id)

    modal.classList.remove("hidden")
    modal.classList.add("flex")
  }

  close(event) {
    const id = event.currentTarget.dataset.modalId
    const modal = document.getElementById(id)

    modal.classList.add("hidden")
    modal.classList.remove("flex")
  }
}