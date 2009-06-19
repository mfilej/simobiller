# Usage

    g clone git://github.com/mfilej/simobiller.git
    cd simobiller
    thor db:create
    thor db:migrate
    cp ~/Downloads/specifikacija_*.xml data
    thor invoices:import
    

Setup passenger or simply run

    ruby site.rb

for a quick glance through the web interface or run

    ./console

to make queries by yourself.