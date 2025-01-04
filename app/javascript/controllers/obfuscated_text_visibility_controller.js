// app/javascript/controllers/obfuscated_text_visibility_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text", "button"]; 

  connect() {
    this.isVisible = false;
    this.update();
  }

  toggle() {
    this.isVisible = !this.isVisible;
    this.update(); 
  }

  update() {
    if (this.isVisible) {
      this.textTarget.textContent = this.data.get("content");
      this.buttonTarget.textContent = "Hide Text";
    } else {
      const length = this.data.get("content").length;
      this.textTarget.textContent = "•".repeat(length);
      this.buttonTarget.textContent = "Show Text";
    }
  }
}
