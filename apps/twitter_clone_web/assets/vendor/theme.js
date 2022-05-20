if (localStorage.theme === 'dark' ) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
}
console.log("loaded")

const button = document.getElementById('theme-button')
button.addEventListener('click', handleButton)

function handleButton () {
    console.log('clicked')
    if (localStorage.theme === 'dark') {
        localStorage.removeItem('theme')
        document.documentElement.classList.remove('dark')

    }
    else {
        localStorage.setItem('theme', 'dark')
        document.documentElement.classList.add('dark')
    }
}