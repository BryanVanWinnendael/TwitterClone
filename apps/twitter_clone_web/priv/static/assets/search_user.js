USERS_API_URL = 'http://localhost:4000/api/public/users'

const search_result = document.getElementById('search-results')
const search_input = document.getElementById('search_users')
const search_box = document.getElementById('search-box')

search_input.addEventListener('input', () => {
    if(search_input.value.length == 0) {
        search_result.innerHTML = ''
        search_box.style.display = 'none'
        return
    }
    search_box.style.display = 'flex'

    fetch(USERS_API_URL)
        .then(response => response.json())
        .then(data => {
            console.log(data)
            let users = data.data.filter(user => {
                console.log(user)
                return user.username.toLowerCase().includes(search_input.value.toLowerCase())
            }
            )
            search_result.innerHTML = ''
            // 5 first users in users array will be displayed
            for(let i = 0; i < 5; i++) {
                if(users[i]) {
                    search_result.innerHTML += `
                    <a href="/users/${users[i].id}" class="pl-4 pr-2 py-1 round-lg border-b-2 p-4 border-gray-100 relative cursor-pointer hover:bg-gray-300 dark:hover:bg-gray-800 hover:text-gray-900 dark:text-gray-200 flex">
                        
                        <img class="md rounded-full relative border-2 h-6 w-6 mr-2" src=${users[i].profile_image}  alt="">
                        <b>${users[i].username}</b>
                    </a>
                    `
                }
            }
        }
        )
}
)



