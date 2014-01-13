snowbank
========


Simple and Flexible
===================
The basic idea of this project ( currently codenamed snowbank ), is to provide a very simple framework that provides a way of relating and accessing different data types, even from disparit systems.

Take for example, the idea of a ticket system. There are a plethora of systems that do any task you can imagine; but few allow for an easy addition of say, an asset tracking system. Even fewer allow for an addition of a proprietary source control system.

Being able to reference a ticket in source control is nothing new, but being able to define what can be referenced in an intuitive system, and the ability to create arbitrary documents and data types, is currently not available.

For example:
 * the ticket document would contain a regex to match ticket links;
 * it would also contain information about how to query for tickets;
 * what fields are required, and so on.

The web interface is going to be a fairly straight forward call/response frontend, with the ability to define new documents.

The ability to interface with outside systems can be achieved in the same; creating a document that defines how to create / list / modify items.
