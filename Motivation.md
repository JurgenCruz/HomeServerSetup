# Motivation

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Motivation.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Motivation.es.md)

When I started my home server I started with an already established product: TrueNAS Scale. It worked really well but right from the start I felt limited. TrueNAS does not support Full System Encryption. I decided to compromise as the data itself could be encrypted, no big deal.

I then tried using the native TrueNAS Apps to set up my media center but some of them were not working. Following a few guides, I stumbled upon a third party catalog of apps called TrueCharts. I gave them a shot and the apps were working this time. I had to jump several hoops, but I finally had it working. Except, a few months later, it broke. I had to join the TrueCharts Discord server and subscribe to their announcement channel because they introduced breaking changes and users had to follow some instructions to fix their system. I thought "OK, fair enough. This should be a rare occurrence". Turns out, it was more regular than I expected.

As months passed, I noticed several people complaining about TrueCharts breaking too often. I also noticed that there was some kind of feud or at least some tension between the devs of TrueCharts and TrueNAS. I seldomly needed help during a breakage from TrueCharts team and asked help in the Discord server, and while I did get support, the attitude of some of the persons was rude. I endured it as my home server was on the line and I needed to get it running.

At one point I needed to do a sensitive operation on my server and I once again asked for help. I wanted to be very sure that I was not going to break my system and lose precious data. I asked a lot of questions but the responses I was getting were basically "Just follow the guide" in a condescending and elitist tone. While I can follow a guide blindly, I would prefer to understand what is happening to my system. Specially if the guide asks you to run commands that you don't know what they do. Things did not end well and I decided that was the last time I used their products.

That is also when I decided I was going to make my own server and not depend on a single entity, and here we are now.

[<img width="50%" src="buttons/prev-Objective.svg" alt="Objective">](Objective.md)[<img width="50%" src="buttons/next-Features.svg" alt="Features">](Features.md)

<details><summary>Index</summary>

1. [Objective](Objective.md)
2. [Motivation](Motivation.md)
3. [Features](Features.md)
4. [Design and justification](Design%20and%20justification.md)
5. [Minimum prerequisites](Minimum%20prerequisites.md)
6. [Guide](Guide.md)
    1. [Install Fedora Server](Install%20fedora%20server.md)
    2. [Configure Secure Boot](Configure%20secure%20boot.md)
    3. [Install and configure Zsh (Optional)](Install%20and%20configure%20zsh%20optional.md)
    4. [Configure users](Configure%20users.md)
    5. [Install ZFS](Install%20zfs.md)
    6. [Configure ZFS](Configure%20zfs.md)
    7. [Configure host's network](Configure%20hosts%20network.md)
    8. [Configure shares](Configure%20shares.md)
    9. [Register DDNS](Register%20ddns.md)
    10. [Install Docker](Install%20docker.md)
    11. [Create Docker stack](Create%20docker%20stack.md)
    12. [Configure applications](Configure%20applications.md)
    13. [Configure scheduled tasks](Configure%20scheduled%20tasks.md)
    14. [Configure public external traffic](Configure%20public%20external%20traffic.md)
    15. [Configure private external traffic](Configure%20private%20external%20traffic.md)
    16. [Install Cockpit](Install%20cockpit.md)
7. [Glossary](Glossary.md)

</details>
