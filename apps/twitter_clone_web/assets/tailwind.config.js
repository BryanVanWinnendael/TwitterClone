module.exports = {
  darkMode: 'class',
  mode: 'jit',
  purge: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      backgroundImage: {
        'search-icon': "url('/images/search.svg')",
        'heart-icon': "url('/images/heart.svg')",
        'heart-icon-dark': "url('/images/heart_dark.svg')",
        'comments-icon': "url('/images/comment.svg')",
        'comments-icon-dark': "url('/images/comment_dark.svg')",
        'heart-icon-filled': "url('/images/heart_filled.svg')",
        'heart-icon-filled-dark': "url('/images/heart_filled_dark.svg')",
        'delete-icon': "url('/images/delete.svg')",
        'delete-icon-dark': "url('/images/delete_dark.svg')",
      },
      backgroundSize: {
        'search-icon': '1.5rem',
        'heart-icon': "auto",
        'heart-icon-filled': "auto",
        'delete-icon': "auto",
        'comments-icon': "auto",
      },
      gridTemplateColumns: {
        'main': '0.3fr 1fr 0.5fr',
        
      },
      backgroundPosition: {
        'search-icon': '10px'
      },
      maxWidth: {
        'login': '15rem',
      },
      colors: {
        'main': '#62b2ed',
        'hover' : '#85a5e0',
        'mainDark' : '#0e0e10',
        'accentDark' : '#121212',
      },
    


    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    function ({addUtilities}) {
        const extendUnderline = {
            '.underline': {
                'textDecoration': 'underline',
                'text-decoration-color': '#8db4fc',
            },
        }
        addUtilities(extendUnderline)
    }
],
}
