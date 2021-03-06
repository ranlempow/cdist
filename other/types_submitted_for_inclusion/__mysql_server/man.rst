cdist-type__mysql_server(7)
===========================
Manage a MySQL server

Benedikt Koeppel <code@benediktkoeppel.ch>


DESCRIPTION
-----------
This cdist type allows you to install a MySQL database server. The
__mysql_server type also takes care of a few basic security tweaks that are 
normally done by running the mysql_secure_installation script that is provided
with MySQL.


REQUIRED PARAMETERS
-------------------
password
   The root password to set.


OPTIONAL PARAMETERS
-------------------
no_my_cnf
   The /root/.my.cnf file is used to temporary store the root password when doing
   the mysql_secure_installation. If you want to have your own .my.cnf file, then
   specify --no_my_cnf "true".
   Cdist will then place your original /root/.my.cnf back once cdist has run.


EXAMPLES
--------

.. code-block:: sh

    # to install a MySQL server
    __mysql_server

    # to install a MySQL server, remove remote access, remove test databases 
    # similar to mysql_secure_installation, specify the root password
    __mysql_server --password "Uu9jooKe"
    # this will also write a /root/.my.cnf file

    # if you don't want cdist to write a /root/.my.cnf file permanently, specify
    # the --no_my_cnf option
    __mysql_server --password "Uu9jooKe" --no_my_cnf


SEE ALSO
--------
- `cdist-type(7) <cdist-type.html>`_


COPYING
-------
Copyright \(C) 2012 Benedikt Koeppel. Free use of this software is
granted under the terms of the GNU General Public License version 3 (GPLv3).
