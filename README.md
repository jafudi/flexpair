# PairPac enables hands-on co-creation anywhere

PairPac stands for "Pair programming Platform as Code". This is the use case we started from. Then we quickly realized that you can use PairPac in so many more situations. PairPac is especially suitable for you and your team, if you are looking for a virtual creative space that is developed with continuous emphasis on the following design principles:

- Interactive, not Big Brother
- Flexible usage, not volatile
- Persistent, not locked-in by contract
- Open standards, not insecure
- Modular, not a workaround
- Scalable, not off-the-shelf

and last but not least achieves:
- less consumption (RAM, bandwidth) yet more reliability

The least thing we want is to waste your precious time. Therefore, please do not read any further

- if you are keen on inviting every work contact into your living room, you are probably better off using [Zoom](https://zoom.us), [WebEx](https://www.webex.com/de/index.html), [Jitsi](https://jitsi.org) etc.
- if you really need to give someone remote access to your local machine, please consider using [TeamViewer](https://www.teamviewer.com/en/) or comparable established solutions

In any other case, we would love to have you as our valued customer.

## Market Analysis

According to a [press release from Gartner in July 2020](https://www.gartner.com/en/newsroom/press-releases/2020-07-23-gartner-forecasts-worldwide-public-cloud-revenue-to-grow-6point3-percent-in-2020) the market demand for cloud-based desktop-as-a-service (DaaS) will rise to 2.535 billion USD in 2022. This consitutes the Total Addressable Market (TAM) which is, of course, totally unrealistic to achieve with our product in the near future.

We deliberately chose to focus on Linux as our guest operating system for a variety of reasons that software developers in particular will immediately understand. In order to quantify the preference for UNIX-based operating systems over Windows, we analyzed the raw data from [Stack Overflow's 2020 user survey](https://insights.stackoverflow.com/survey/2020) and found that 23.2% of professional developers are already using Linux as their primary desktop, 25.0% were on MacOS and 16.0% were Windows users explicitely stating that they would rather prefer to work on Linux. Extrapolating from the 64462 valid responses to the survey, we are confident to conclude that 64.3% of global pro-developers are affine to UNIX and would dislike being forced to use Windows on a virtual desktop.

But also people working in other sectors like education and media as well as finance value the security and stability of Linux. A whopping 16.9% of all Ubuntu users work in finance according to [21,291 survey responses in April 2020](https://ubuntu.com/blog/ubuntu-20-04-survey-results). These verticals on top of IT add up to a little over 50% of the whole market according to [Marketysers Global Reports And Data](https://www.reportsanddata.com/report-detail/desktop-virtualization-market). Considering that there are some Linux users in the other half of verticals as well, we consider a Servicable Adressable Market (SAM) of around 0.500 x 0,643 x TAM not as an overestimate. For the year 2022 this means we expect 815 million USD or 675 million EUR demand for LINUX-based DaaS solutions.

Finally, the Servicable Obtainable Market (SOM) is likely the small and medium size businesses (about 20% of the market), as the more established [competitors](https://www.g2.com/products/shells-com/competitors/alternatives) catering to large enterprises come with a hefty price tag.

## Selected use cases

### Change society towards fair intellectual property and fair healthcare

- ☁️ Brain storming and technology brokering for everyone 🧠💡♻
- 🪁 Patient-centered healthcare for everyone 🏥👩‍⚕️️🩺🤕🧘📧👩🏾‍🔬‍🧫🔬
- Keep track of the whole interaction history in one place
- Maintain data privacy by locking out data collectors
- No additional software: use your favorite web browser without installation

### Enable effective and human-friendly remote work

- 🏄 Seamless task delegation to remote assistants 👩🏻‍💼👉🏻✅👂🏼‍🧞‍♂️
- 🏄 Interactive remote team programming  🌎🏝👨‍💻♾👩‍💻☕🏠
- Unified tool for synchronous and asynchronous collaboration
- Fully reproducible environment through infrastructure-as-code with [Terraform](https://www.terraform.io)
- Combine (free) resources across all major cloud providers
- Keep your private space private: no webcams involved


### Support mutual understanding through culture and leisure

- 🐟 Professional podcast production across the globe 👳🏿‍♂️🎙🎛⟷🎙👨🏻‍🦰🎧
- 🐚 Virtual karaoke parties 🎉🕺🎶⟷🎤🥳🎼
- High audio quality and low latency at moderate bandwidth requirements using the [Opus Codec](https://opus-codec.org)
- Until all is said: no time limitations whatsoever
- Receive email from your followers on a dedicated email account

Annotation of user goal levels similar to [Cockburn style](https://en.wikipedia.org/wiki/Use_case#Templates)

1. TODO: Assign contacts as well as competitor products to use cases
2. TODO: Ask people on SurveyCircle to come up with their own emojis for how they understand the description

## What is PairPac at its core, technically?

PairPac stands for Pair Programming Platform as Code. More technically, it is a collection of Terraform modules and cloud-init scripts for deploying a shared cloud desktop (Ubuntu 20.04 LTS) with high quality audio conferencing and self-hosted email inbox to an arbitrary public cloud account. Free tier resources are sufficient and multicloud is actively supported.

## Some screenshots

![Some screenshots](./documentation/ezgif.com-gif-maker.gif)
