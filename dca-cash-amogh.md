<!-- Output copied to clipboard! -->

<!-----

Yay, no errors, warnings, or alerts!

Conversion time: 0.257 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β34
* Fri Feb 17 2023 08:39:43 GMT-0800 (PST)
* Source doc: Failed TX Debug

WARNING:
You have 4 H1 headings. You may want to use the "H1 -> H2" option to demote all headings by one level.

----->



# 💵dca.cash

A non-custodial service that allows you to dollar cost average (DCA) into your favourite crypto assets


# The why

I had been searching for a way to dollar cost average into ETH on-chain for a while. However, the current solutions involve locking up your funds or using some kind of weird token wrappers. I didn't want either.

I wanted to be able to store keep the funds in my wallet with no restrictions in their native form (no wrappers). Since the FTX debacle and the crypto public's draw away from CEXes, I figured more people would be interested in using something like this.

Introducing dca.cash!


# How it works

The protocol has a smart contract, and firestore database and a cron job to execute swap at recurrent times.

**The smart contract is registered with the Turnstile contract on Canto and is eligible for CSR.**

Users have to approve the token they want to swap. Then users can create the task and thats it! We charge 0.1% fee per swap to be able to fund gas and other costs.


# Security

Although the users approve the max amount, the approval is locked by TimedAllowance which releases only the amount specified by the user and at only the specified interval.


# How you can use it

Easy! You can head over to https://dca.cash and start DCA-ing now! Please do reach out to me for questions or feedback!
