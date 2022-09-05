import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cretor-autocomplete"
export default class extends Controller {
  static values = {}

  static target = ['creator']

  connect() {
    console.log('Hello World!')
  }
  
}
