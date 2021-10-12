# putzplan

The PutzPlan (german for cleaning plan) is a locally hosted web application,
that is supposed to help me and my roommates managing cleaning task in our shared apartment.

It's a fun little project to use, repeat and train my knowledge in software design and engineering.
This project is unfinished and therefor the documentation will be added later.

PutzPlanClient is the just front end, and the back end can be found in another repository called PutzPlanServer (hereinafter referred to as 'server').
The PutzPlanClient is based on Flutter.

It's used as an interface for the user to interact with the server:

The user can authenticate himself, with username and password.
If the authentication works, his tasks and other information(e.g. logs, presence of users) will be loaded from the server.
He can finish a task, which will update the server and load the new data.
He can declare another user as present or absent, which will update the server and load the new data.
The tasks of an absent user will be available for everyone, the tasks of a present user are only available for him.

This is just the basic functionality and will be described more detailed in the future.
