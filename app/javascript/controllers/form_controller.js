import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["file", "avatar", "form"]
  selectAvatar(){
    this.fileTarget.addEventListener('change', event => {
      const reader = new FileReader()
      const avatar = this.avatarTarget
      reader.addEventListener('load', () => {
        avatar.src = reader.result
        avatar.height = '300'
      }, false)
      const file = event.target.files[0]
      reader.readAsDataURL(file)
    })
  }

  checkValidate(event) {
    const forms = this.formTarget
    Array.from(forms).forEach(form => {
      console.log(form.checkValidity())
      if (form.checkValidity() === false) {
        form.classList.add('is-invalid')
        event.preventDefault()
        event.stopPropagation()
      }
      form.classList.add('was-validated')
    }, false)
  }
}
