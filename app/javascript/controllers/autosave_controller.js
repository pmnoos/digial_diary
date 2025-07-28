import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.timeout = null
    this.formTarget.addEventListener("input", () => this.queueAutosave())
  }

  queueAutosave() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.autosave(), 2000)
  }

  autosave() {
    fetch(this.formTarget.action, {
      method: "PATCH",
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: new URLSearchParams(new FormData(this.formTarget))
    })
  }
}
