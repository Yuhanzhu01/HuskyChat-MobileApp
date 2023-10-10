**Software Requirements Specification**
**Team name: The Incredibles**

***Purpose***
***Definitions***

An integrated chat platform that allows users to communicate with all members on Northeastern campus, view course-specific details, and help manage their time better. 

***Background***

Users switch through multiple platforms, making it difficult to keep track of things while communicating with other users. For example, it’s hard for students and TAs to manage the timelines (due dates and submission status on Canvas) and communicate (Teams and Zoom) through multiple platforms.
	
***Overall Description***
***User Characteristics  (Demographic)***

Student and TA 

- Age: 16 - 30 (The most common age group)
- Language: all Language
- Gender: all genders
- Culture: all culture
- Location: US based institutions
- Education level: undergrad, graduate, professional study, bootcamp

Professor 

- Age: 40 - 60 (The most common age group)
- Language: all Language
- Gender: all genders
- Culture: all culture
- Location: US based institutions

***User Stories***

Students, TA and Professor:

- As a student, I’d like to see what assignments I have coming up, and then quickly reach out to a classmate to talk about it so that I can have my questions clarified and all know their assignments status 

- As a student, I want instant chat feature with TA and professor so that I can get instant responses for my doubts 

- As a Professor, I want to quickly see what I have coming up in terms of deadlines without having to hit too many buttons.

	
***App Workflow (flowchart)***

![image](https://user-images.githubusercontent.com/115593195/233917228-525b2ca3-c2d7-4eb5-9094-241497cca964.png)




***Requirements***

Functional

    Sign up page which would require a university email and Canvas API Key.

        Login page.

        Logout

        User account in the app.

        Toolbar for switching 

        Canvas Access

        View Courses

        View assignments by due date

        View past assignments

        View assignments by name

        (Nice-to Have) View class participants for professor

    Notifications

        Instant messages received
        
        Mark all as read 

    User Profile

        View username

        View partial Canvas Access Key

        View Email

        Shows Profile picture

    Instant message (Chat) with other users.

        History chat page

        Search users

        Chat with specific user

        Group chat

        Make new group
        
        Search group to join



Non-functional

    Fast performing: Can load in 5 seconds or less with total number of simultaneous users < 5 thousand.

    Scalability: The system should be able to handle 1 million users without crashing.
    Easy to use UI: clear instructions and direction of functionalities, no complicated design.

    Reliable: users get consistent response and desired outcome from system performance.

    Security: the system provides credential verification(eg.canvas access key).

    Aesthetic UI: UI should be clean but also maintain aesthetic, including color matching, shapes placement, font size, etc.

    Concise: metaphor icon is adapted in this platform.

    Multi-platform: users can access all functions in one platform instead of switching.

    Compatibility: app is adapted to all environments and different systems.

    Fast-data look up:  using firebase to achieve fast-data search and response.


***Wireframes (this is a link to a document in your repo)***


![image](https://user-images.githubusercontent.com/115593195/233918496-5861753f-f5ee-4372-b751-d5aac3fe9d00.png)

![image](https://user-images.githubusercontent.com/115593195/233918543-da7e53e8-5252-4944-bfc4-b5edd6764aed.png)

![image](https://user-images.githubusercontent.com/115593195/233918574-20dd459c-3b6f-45b7-94b4-14ece4cc462c.png)

![image](https://user-images.githubusercontent.com/115593195/233918613-0573a6d5-f6e2-4747-a0b2-0e60e0f97afa.png)

![image](https://user-images.githubusercontent.com/115593195/233918684-a878b979-09ad-47a7-80dc-2275107fd4be.png)



***UML Class Diagram***

<img width="468" alt="image" src="https://user-images.githubusercontent.com/115593195/233917800-03681588-a9c4-496a-8de4-892d48178093.png">


	

***Gantt Diagram***

<img width="468" alt="image" src="https://user-images.githubusercontent.com/115593195/233917840-5bde8c18-e70d-466a-8760-6b13334f88e3.png">


***Traceability Matrix***


<img width="882" alt="image" src="https://user-images.githubusercontent.com/115593195/233917934-72414047-a968-4fba-ab5c-57e60ba6b31a.png">


***Project Board***

<img width="468" alt="image" src="https://user-images.githubusercontent.com/115593195/233918064-d4dfa4cc-10e5-4196-af66-7915765a140e.png">









