import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['file', 'avatar', 'form']

  connect() {
    this.fileTarget.addEventListener(
      'change',
      this.displaySelectedAvatar.bind(this)
    )
  }

  displaySelectedAvatar(event) {
    const file = event.target.files[0]

    if (file) {
      if (file.size > 1024 * 1024) {
        this.avatarTarget.src = '/assets/upload_error.svg'
        return
      }

      const reader = new FileReader()
      reader.onload = (e) => {
        this.avatarTarget.src = e.target.result
        this.avatarTarget.height = '300'
      }
      reader.readAsDataURL(file)
    }
  }

  checkValidate(event) {
    const forms = this.formTarget
    Array.from(forms).forEach((form) => {
      if (form.checkValidity() === false) {
        form.classList.add('is-invalid')
        event.preventDefault()
        event.stopPropagation()
      }
      form.classList.add('was-validated')
    }, false)
  }
}
