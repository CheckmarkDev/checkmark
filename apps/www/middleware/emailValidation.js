export default function ({ route, store, redirect, axios }) {
  const { name, query } = route
  if (route.name === 'EmailValidation') {
    const { token } = query
    if (!token) {
      return redirect('/auth/sign-in')
    }

    axios.post('/auth/email-validation', {
      token
    })
      .then(() => {
        return redirect('/auth/sign-in?success=email-validation')
      })
      .catch(() => {
        return redirect('/auth/sign-in?error=email-validation')
      })
  }
}
