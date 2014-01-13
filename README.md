snowbank
========

Basic idea is to have very few specific document types that are used as infrastructure for the system.

From there, arbitrary document types could be defined and utilized.

For example:
 * the ticket document would contain a regex to match ticket links;
 * it would also contain information about how to query for tickets;
 * what fields are required, and so on.

The web interface is going to be a fairly straight forward call/response frontend, with the ability to define new documents.

The ability to interface with outside systems can be achieved in the same; creating a document that defines how to create / list / modify items.
