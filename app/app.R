# =====================================================================
# The Garden Spot - Year Two question app  (GS-Y2)
# Post-class companion. No data is stored or sent anywhere: student
# details are collected ONLY to print on the final score certificate,
# which students screenshot and submit by email/LMS.
# Contains NO case text. Dependency: shiny only. Shinylive-compatible.
# =====================================================================
library(shiny)

EXERCISE_TAG <- "GS-Y2"
MAX_POINTS   <- 635
TARGET_PCT   <- 80
TARGET_PTS   <- 508
SUBMIT_EMAIL <- "vedprakash@gim.ac.in"   # <-- EDIT before deploying
DEADLINE_TXT <- "before midnight tomorrow (July 18)"           # <-- EDIT before deploying

`%||%` <- function(a, b) if (is.null(a)) b else a

STMT_CHOICES <- c("Balance Sheet" = "BS", "Income Statement" = "IS",
                  "Cash Flow Statement" = "CFS",
                  "None of them - nothing gets recorded" = "NONE")
SECT_CHOICES <- c("Operating" = "O", "Investing" = "I", "Financing" = "F")
Y1LINE <- "Year One called - it wants its lesson back."

# ------------------------------ CONTENT ------------------------------
TXNS <- list(

list(id="E1", emoji="\U0001F91D", label="Event 1 - Lawrence invests $20,000 for shares",
  hook="Remember the Cash Mystery? Mary Jo does. Enter Jake Lawrence, chequebook open.",
  predict=c("BS","CFS"), dbl=FALSE,
  pfb=list(IS_extra=paste(Y1LINE,"Owners aren't customers; nothing was earned."),
           CFS_miss="Real cash arrived. The bank-account diary gets an entry.",
           NONE_extra="Cash in, ownership out. Very recorded.",
           BS_miss="Every transaction touches the balance sheet - still true this year."),
  section="F",
  sfb=c(O="No plants were sold to Lawrence - he bought a piece of the company. Financing.",
        I="Investing is the company buying assets. Here someone bought the COMPANY's shares."),
  mcqs=list(
    list(q="The Garden Spot was PROFITABLE in Year One. So why is Mary Jo out raising money at all?",
      opts=c("Because profit was too small to matter.",
             "Because operations BURNED $64,990 of cash last year - profit and cash are different animals, and the cash animal was starving.",
             "Because the bank demanded more equity."),
      ans=2,
      fb=c("$5,610 is modest, but that's not the wound. Look at a different statement.",
           "Exactly - you solved this mystery yourself last session. Growth eats cash: receivables and inventory swallowed the money profit promised. Lawrence's $20,000 is the transfusion.",
           "Plausible in real life, but nothing says so - and the deeper answer sits in last year's cash flow statement.")))),

list(id="E2", emoji="\U0001F3DE", label="Event 2 - Land bought July 1 for $100,000 ($10,000 cash + $90,000 new loan)",
  hook="The biggest number of the year, and only $10,000 of cash moved. Watch what the CFS does with that.",
  predict=c("BS","CFS"), dbl=FALSE,
  pfb=list(IS_extra="Land is the ultimate asset - it doesn't even depreciate (you predicted this in Year One, T10). No expense today. Or ever.",
           CFS_miss="$10,000 of cash left - and the CFS will say far more than that. See the next question.",
           NONE_extra="A $100,000 asset and a $90,000 loan appeared. Plenty recorded.",
           BS_miss="Land +100,000, Loan +90,000, Cash -10,000 - the balance sheet grew a whole new district."),
  section=c("I","F"), section_note="More than one tick needed - again.",
  section_win="Elegant part: the CFS shows this GROSS - Investing -100,000, Financing +90,000 - even though only $10,000 net moved. Statements prefer full stories to net summaries: readers should SEE both the big purchase and the big borrowing.",
  sfb=c(I_only="Half the story. Where did $90,000 of the purchase money come FROM? A lender - and the CFS reports that arrival separately.",
        F_only="Half the story. A $100,000 asset was BOUGHT - that investment must show, gross.",
        O="Nothing here is the daily plant business - this is a once-a-decade move."),
  mcqs=list(
    list(q="Only $10,000 of cash left the company. Why does the CFS report a $100,000 investing outflow?",
      opts=c("It's an error in the case solution.",
             "Gross presentation: the statement separates the investment decision (-100,000) from the financing decision (+90,000) so readers see both.",
             "Because land is always shown at $100,000 minimum."),
      ans=2,
      fb=c("The case-writer sleeps soundly. This is deliberate.",
           "Right - netting them would hide that the company just made its biggest bet ever using 90% borrowed money. That fact deserves daylight.",
           "No minimums in accounting - only what happened.")))),

list(id="E3", emoji="\U0001FAB4", label="Event 3 - Inventory $310,000 ($240,000 cash, $70,000 on account)",
  hook="Speed round: you did this exact dance in Year One. Prove it.",
  predict=c("BS","CFS"), dbl=FALSE,
  pfb=list(IS_extra=paste(Y1LINE,"Inventory is an expense-in-waiting; the trigger is the SALE."),
           CFS_miss="$240,000 of cash left. Very noticeable.",
           NONE_extra="A yard full of plants and a supplier owed $70,000 disagree.",
           BS_miss="Inventory up, cash down, payables up - three balance-sheet moves."),
  section="O",
  sfb=c(I="Inventory is the operating heartbeat, not a long-lived investment.",
        F="No owners or lenders - just the cycle turning."),
  mcqs=list()),

list(id="E4", emoji="\U0001F4B0", label="Event 4 - Sales $500,000 ($400,000 cash, $100,000 credit); cost of goods sold $300,000",
  hook="The engine roars: sales up 25% on last year. Two rows in your worksheet, one question here.",
  predict=c("BS","IS","CFS"), dbl=FALSE,
  pfb=list(IS_miss="Delivery happened - revenue was EARNED. This is the income statement's whole reason to exist.",
           CFS_miss="$400,000 of customer cash - the year's biggest inflow.",
           NONE_extra="The single busiest recording moment of the year.",
           BS_miss="Cash, receivables, inventory, retained earnings - all moved."),
  section="O",
  sfb=c(I="Selling plants IS the operation.", F="Customers, not financiers."),
  mcqs=list(
    list(q="Sales rose 25%, and $100,000 of them are on credit (vs $85,000 last year). Nothing wrong yet - but which statement will quietly keep score of whether these customers actually pay?",
      opts=c("The Income Statement.",
             "The Balance Sheet - receivables pile up there until cash arrives, and a growing pile is a growing question.",
             "The Cash Flow Statement."),
      ans=2,
      fb=c("The IS already declared victory at delivery. It never looks back.",
           "Right - and hold that thought. In a few events, one receivable starts looking sick, and the Detective Round will weigh the whole pile.",
           "The CFS records only arrivals. Money that HASN'T arrived is invisible to it - which is exactly why the balance sheet must remember.")))),

list(id="E5", emoji="\U0001F4C3", label="Event 5 - Operating expenses $150,000, all paid in cash",
  hook="Speed round continues. Consumed benefits, instant expense - say it in your sleep.",
  predict=c("BS","IS","CFS"), dbl=FALSE,
  pfb=list(IS_miss="These benefits are already consumed - expense, immediately (Year One, T7).",
           CFS_miss="$150,000 of cash left.",
           NONE_extra="A very expensive nothing, then.",
           BS_miss="Cash and retained earnings both fell."),
  section="O",
  sfb=c(I="Nothing long-lived bought.", F="No financiers involved."),
  mcqs=list()),

list(id="E6", emoji="\U0001F4B8", label="Event 6 - Bank payment $13,000 ($10,000 principal + $3,000 interest, old loan)",
  hook="One cheque, two stories - the sequel. Your worksheet split it; can your instincts?",
  predict=c("BS","IS","CFS"), dbl=FALSE,
  pfb=list(IS_miss="The $3,000 interest is this year's rent for the bank's money - an expense.",
           CFS_miss="$13,000 of real cash to the bank.",
           NONE_extra="A shrinking loan, shrinking cash, and an expense. Plenty.",
           BS_miss="The old loan drops from $30,000 to $20,000."),
  section=c("F","O"), section_note="Two ticks. You know why.",
  section_win="Principal to Financing, interest to Operating - the Year One split, now reflex. (Interest is $3,000 this year because the outstanding balance fell to $30,000 - 10% of it.)",
  sfb=c(F_only="The interest piece is Operating - the recurring cost of borrowed money.",
        O_only="The principal piece is Financing unwinding.",
        I="Nothing was bought - money returned to its lender, plus rent."),
  mcqs=list()),

list(id="E7", emoji="\U0001F47B", label="Event 7 - Last December's $5,000 wages paid in January",
  hook="A ghost from Year One walks in on payday. You created this liability yourself - Transaction 9, remember? Careful with your first answer.",
  predict=c("BS","CFS"), dbl=FALSE,
  pfb=list(IS_extra="The expense already happened - LAST year, when the work was done (your own Year One answer!). Recording it again would charge the company twice for one December. This year: liability dies, cash leaves, the income statement never looks up.",
           CFS_miss="$5,000 of cash left in January. The diary records it.",
           NONE_extra="Cash left and a debt vanished - two recordable events.",
           BS_miss="Wages Payable $5,000 just died. The balance sheet noticed the funeral."),
  section="O",
  sfb=c(I="Paying staff is as operating as it gets.", F="Employees are not financiers (they may disagree)."),
  mcqs=list(
    list(q="A $5,000 cash payment with ZERO expense this year. What one-line rule does this prove?",
      opts=c("Wages are only expenses in the year they're paid.",
             "Expense follows the WORK; cash follows the PAYMENT; a liability bridges the gap between them.",
             "Small payments skip the income statement."),
      ans=2,
      fb=c("Precisely backwards - and Year One's Transaction 9 is the counter-example you already solved.",
           "That sentence is the whole architecture of accrual accounting. You'll use it three more times before this session ends.",
           "Size rules retired in Year One. Permanently.")))),

list(id="E8", emoji="\U0001F4E5", label="Event 8 - Collected $60,000 from customers on account",
  hook="Money flooding in from last year's credit sales. Feels like revenue. Smells like revenue. Is it?",
  predict=c("BS","CFS"), dbl=FALSE,
  pfb=list(IS_extra="This revenue was recognized at DELIVERY - much of it last year. Collecting now is a promise converting into cash: receivable down, cash up, income statement unmoved. Recognizing it again counts one sale twice.",
           CFS_miss="$60,000 arrived. Cash flow statements live for this.",
           NONE_extra="An asset changed form: promise into money. Recorded.",
           BS_miss="Receivables shrank, cash grew - a balance-sheet shuffle."),
  section="O",
  sfb=c(I="Collecting from customers is the operating cycle completing itself.",
        F="Customers aren't lenders (though slow ones behave like borrowers)."),
  mcqs=list(
    list(q="The mirror test. Last year: sale without cash was revenue. This year: cash without sale is not. What single idea explains both?",
      opts=c("Revenue needs BOTH a sale and cash in the same year.",
             "Revenue attaches to the EARNING event (delivery), wherever the cash falls. Cash timing is logistics, not performance.",
             "The first transaction in any pair carries the revenue."),
      ans=2,
      fb=c("Then last year's credit sales couldn't have been revenue - but they were.",
           "Correct - and notice you can now predict any collection or payment event's treatment without thinking. That's fluency.",
           "Order isn't the principle - earning is.")))),

list(id="E9", emoji="\U0001F4E2", label="Event 9 - $5,000 paid July 1 for advertising running through next June 30",
  hook="Year One, T7, we asked a hypothetical: 'What if rent were paid for NEXT year?' You answered: asset, called Prepaid. Mary Jo just made your hypothetical real.",
  predict=c("BS","CFS"), dbl=FALSE,
  pfb=list(IS_extra="Not so fast - on July 1, ALL the benefit is still in the future. A purchased future benefit is an asset: Prepaid Advertising. (Keep your pencil out - a year-end adjustment is coming with your name on it.)",
           CFS_miss="$5,000 of cash left in July.",
           NONE_extra="Cash out, asset in. Recorded.",
           BS_miss="A brand-new asset line appeared: Prepaid Advertising."),
  section="O",
  sfb=c(I="Ad campaigns aren't long-lived assets - just pre-bought operating benefit.",
        F="No financiers, just a marketing firm."),
  mcqs=list()),

list(id="E10", emoji="\U0001F4E4", label="Event 10 - Paid suppliers $60,000 owed on account",
  hook="Old bills, settled. If E7 and E8 taught you anything, this takes four seconds.",
  predict=c("BS","CFS"), dbl=FALSE,
  pfb=list(IS_extra="Third time's the pattern: settling an old promise is never an expense. The inventory those payables financed hits the IS only as COGS, only when sold.",
           CFS_miss="$60,000 to suppliers. Cash. Gone.",
           NONE_extra="A debt died and cash left. Recorded twice over.",
           BS_miss="Payables down, cash down - both sides of the sheet shrank together."),
  section="O",
  sfb=c(I="Suppliers of plants, not of machines.", F="A supplier is not a bank (even when they act like one)."),
  mcqs=list()),

list(id="E11", emoji="\U0001F381", label="Event 11 - $10,000 deposit received in November for plants deliverable in February",
  hook="A customer hands over $10,000 for plants that don't exist yet. Cash in hand, nothing delivered. Last year you met this creature's mirror image...",
  predict=c("BS","CFS"), dbl=FALSE,
  pfb=list(IS_extra="The company hasn't EARNED a rupee of it - no plants have moved. Until delivery, this cash is a DEBT: the company owes the customer plants or a refund. Welcome to Unearned (Deferred) Revenue - promised to you in Year One, T6.",
           CFS_miss="$10,000 of very real cash arrived in November.",
           NONE_extra="Cash arrived and an obligation was born. Both recorded.",
           BS_miss="Cash up AND a new liability up - the sheet grew on both sides."),
  section="O",
  sfb=c(I="Customer money for future plants is still the plant business.",
        F="The customer isn't lending - they're pre-buying. (Economically similar, legally different, accounting-wise: a liability either way.)"),
  mcqs=list(
    list(q="Complete the symmetry. Accounts Receivable is delivery-before-cash. A customer deposit is cash-before-delivery. So on the balance sheet, the deposit must be...",
      opts=c("An asset, like receivables - both involve customers.",
             "A liability - the company now OWES the customer delivery (or a refund). Obligations live on the right side.",
             "Revenue, held at 50% until delivery."),
      ans=2,
      fb=c("Direction matters! A receivable is money OWED TO us. A deposit is performance OWED BY us.",
           "Perfect. And note the quiet oddity: this deposit IMPROVED cash flow while creating a debt. Companies that collect advances - airlines, gyms, subscriptions - run on this beautiful engine.",
           "Accounting doesn't do half-recognitions on a hunch. Zero now, full amount at delivery in February.")))),

list(id="E12", emoji="\U0001F91D", label="Event 12 - Contract signed in November: $20,000 of plants for February. No goods moved, no cash received.",
  hook="A $20,000 handshake - the biggest sales contract in company history. Surely SOMETHING gets recorded...",
  predict="NONE", dbl=TRUE,
  pfb=list(notnone="Eleven times last year and many times today, 'None' was a trap. THIS time it's the answer. No cash moved (unlike E11's deposit). Nothing was delivered (so nothing is earned). A promise-for-a-promise - an executory contract - lives in the manager's diary and maybe the footnotes, but not in the accounts."),
  win="\U0001F389 The option finally pays - double points! Compare with E11: the ONLY difference is that cash moved there. Cash or delivery starts the accounting; a handshake alone does not.",
  section=NULL,
  mcqs=list(
    list(q="So what separates E11 (recorded) from E12 (not recorded)?",
      opts=c("E11's customer is more trustworthy.",
             "In E11, something REAL already happened - cash changed hands, creating an obligation. In E12, both sides have only promised; neither has performed.",
             "$20,000 is below the recording threshold."),
      ans=2,
      fb=c("Trust is a lending decision, not a recording trigger.",
           "Exactly - accounting waits for performance or payment. This is also why 'order books' companies boast about in press releases are nowhere on their balance sheets. Now you know to ask where such numbers actually live.",
           "It's TWICE E11's amount. Thresholds were never the rule.")))),

list(id="E13", emoji="\U0001F912", label="Event 13 - A customer owing $2,000 probably can't pay",
  hook="One of last year's promises is going pale. Mary Jo hasn't given up collecting - but she has serious doubts. Doubt, it turns out, is an accounting event.",
  predict=c("BS","IS"), dbl=FALSE,
  pfb=list(CFS_extra="No cash moved - that's precisely the tragedy. The cash this represents may simply never arrive.",
           NONE_extra="Doubt this serious must be recorded - waiting for certainty would let the sheet show $2,000 of probable fiction.",
           IS_miss="A probable loss belongs against this year - that's an expense (bad debts).",
           BS_miss="The receivables pile just got $2,000 lighter in substance - the sheet must say so."),
  section=NULL,
  mcqs=list(
    list(q="She hasn't given up collecting. Why record the bad news NOW instead of waiting for a definitive default?",
      opts=c("Tax deduction timing.",
             "Conservatism + matching: probable losses are recorded when they become probable, and this one belongs against this year's activities - not parked until certainty arrives.",
             "Because the auditor insists."),
      ans=2,
      fb=c("Taxes follow accounting here, not the other way round.",
           "Right - accounting is an early-warning system, not an obituary column. Recall Year One, T4: 'we record bad news faster than good.' The land offer (coming shortly) is the other half of that sentence.",
           "Auditors enforce the principle; they didn't invent the customer's troubles.")),
    list(q="An expense of $2,000... with no cash leaving, now or maybe ever. Which Year One expense does this rhyme with?",
      opts=c("Interest expense.",
             "Depreciation - both are expenses that adjust an ASSET's carrying value rather than moving cash.",
             "Wages expense."),
      ans=2,
      fb=c("Interest eventually demands real cash. This might never involve cash again.",
           "Good ear. Non-cash expenses are a family: depreciation, bad debts, and later, impairments. All will matter enormously when we rebuild cash flow FROM profit at the finale.",
           "Wages are the most cash-bound expense there is - just delayed sometimes.")))),

list(id="E14", emoji="\U0001F527", label="Event 14 - Equipment sold Jan 1 for $600 cash (original cost $1,000; book value $800)",
  hook="The first time The Garden Spot has ever SOLD an asset. Three numbers - 1,000, 800, 600 - and only one of them is the loss. Choose wisely.",
  predict=c("BS","IS","CFS"), dbl=FALSE,
  pfb=list(IS_miss="She received less than the asset's remaining book value - that shortfall is a loss, and losses live on the income statement.",
           CFS_miss="$600 of cash arrived. Small, but the diary records everything.",
           NONE_extra="An asset left, cash arrived, a loss was suffered. Three recordings.",
           BS_miss="Equipment shrank by its $800 book value; cash grew by $600."),
  section="I",
  sfb=c(O="Selling PLANTS is operating. Selling the EQUIPMENT that sold the plants is investing - the T3 logic, reversed.",
        F="Nobody financed anything - an asset was liquidated."),
  mcqs=list(
    list(q="The loss is...",
      opts=c("$400 - she got 600 for something that cost 1,000.",
             "$200 - she received $600 for something the books carried at $800.",
             "$600 - the whole sale price, since the asset is gone."),
      ans=2,
      fb=c("The $1,000 is ancient history; $200 of it was already expensed as Year One depreciation. Counting it again double-charges.",
           "Right: loss = proceeds minus BOOK value - the cost not yet expensed. The sale settles that account once and for all.",
           "The $600 is the good news (cash received), not the bad.")),
    list(q="The strange arithmetic: the CFS shows +$600 coming IN while the IS shows -$200 of loss. Both, simultaneously. How?",
      opts=c("One of the statements must be wrong.",
             "They answer different questions: the CFS asks 'how much cash arrived?' ($600); the IS asks 'did we get more or less than the asset's remaining cost?' (less, by $200).",
             "The $200 loss reduces the $600 to a net $400 inflow."),
      ans=2,
      fb=c("Both are right - which is the point of having two statements.",
           "Beautiful - one event, two instruments, each telling its own truth. Remember this: it becomes an add-back puzzle in the grand finale.",
           "Cash doesn't shrink because the books are sad. $600 arrived. All of it.")))),

list(id="E15", emoji="\U0001F3DE", label="Event 15 - A developer offers $120,000 for the land. Mary Jo declines.",
  hook="The land bought for $100,000 in July is 'worth' $120,000 by December. Mary Jo is delighted. Her accountant reaches for the coffee, not the pen.",
  predict="NONE", dbl=TRUE,
  pfb=list(notnone="You predicted this yourself in Year One (T4: the equipment whose price doubled). An unaccepted offer changes nothing the company OWNS or OWES - historical cost holds, the land stays at $100,000. And a gain is recognized when REALIZED, by actually selling. Declined offers produce smiles, not income."),
  win="\U0001F389 Second payoff - double points! Feel the asymmetry with E13: probable LOSS of $2,000 recorded immediately; probable GAIN of $20,000 ignored entirely. That one-way door is called conservatism, and it is the personality of the whole discipline.",
  section=NULL,
  mcqs=list(
    list(q="A shareholder complains: 'The land is worth $120,000 - why does the balance sheet LIE and say $100,000?' Best reply?",
      opts=c("It's a known flaw; statements are simply out of date.",
             "The balance sheet reports verifiable cost, not opinions of value. One developer's offer is an opinion; the $100,000 payment is a fact. Readers wanting value estimates must look beyond the statements - knowingly.",
             "She should sell and repurchase the land to record the gain."),
      ans=2,
      fb=c("Not a flaw - a design choice, with reasons.",
           "Exactly - and Kohli sends his regards (Year One, T1): valuable things statements deliberately exclude. A balance sheet is a photograph of costs, not an appraisal of worth. Analysts add the worth; accountants guard the facts.",
           "Congratulations, you've invented a transaction-cost machine. Real firms have tried games like this. It ends with regulators.")))),

list(id="E16", emoji="\U0001F4DC", label="Event 16 - December 31: dividend of $8,000 declared, payable January 31",
  hook="The board's year-end gift to shareholders - declared today, paid next month. Here comes the strangest first answer in two years of this case.",
  predict="BS", dbl=FALSE,
  pfb=list(IS_extra="The oldest trap in the book: a dividend is NOT an expense. Expenses are costs of EARNING profit; a dividend is a DISTRIBUTION of profit already earned. It reduces Retained Earnings directly, below the income statement's line of sight.",
           CFS_extra="Declared, not paid - not a rupee moved on December 31. (January 31's CFS - next year's - will feel it, in Financing.)",
           NONE_extra="Retained Earnings fell and a new liability - Dividend Payable - was born. Recorded.",
           IS_miss=NULL, CFS_miss=NULL,
           BS_miss="Retained Earnings -8,000, Dividend Payable +8,000."),
  win="The only balance-sheet-ONLY event in the entire two-year case: Retained Earnings -8,000, Dividend Payable +8,000. One statement, working alone.",
  section=NULL,
  mcqs=list(
    list(q="Why, precisely, is a dividend not an expense - even though money will genuinely leave the company?",
      opts=c("Because it's optional, and expenses are mandatory.",
             "Because it doesn't help EARN revenue - it's the reward AFTER earning, flowing to owners. Expenses buy performance; dividends distribute its results.",
             "Because it's under $10,000."),
      ans=2,
      fb=c("Advertising is optional too, and it's an expense. Optionality isn't the line.",
           "Right - which means profit is computed BEFORE anyone thinks about dividends, so profit stays comparable between generous firms and stingy ones.",
           "We retired size-based rules four hundred questions ago.")),
    list(q="Trace the $8,000 forward. WHERE and WHEN will it finally touch a cash flow statement?",
      opts=c("This year, Operating.",
             "Never - dividends bypass the CFS.",
             "Next year, in Financing - when the payable is settled on January 31."),
      ans=3,
      fb=c("No cash this year, and dividends aren't operations regardless.",
           "Cash cannot leave a company invisibly. Every rupee out passes through some CFS eventually.",
           "Exactly - declare (BS only), owe (Dividend Payable), pay (next year's CFF). One decision, three chapters, two accounting years. You have now personally witnessed why balance sheets exist: to carry unfinished stories across year-end.")))),

list(id="A17", emoji="\U0001F4C9", label="Mary Jo's doubt 17 - 'Do I record depreciation on the truck and equipment?'",
  hook="Her first year-end worry. You already know THAT the answer is yes - the question is how much, and why it changed.",
  predict=c("BS","IS"), dbl=FALSE,
  pfb=list(CFS_extra="Still no cash - the money left back in Year One. Depreciation never touches the CFS directly.",
           NONE_extra="A year of asset-service was consumed. Recorded, as last year.",
           IS_miss="One more year of the assets' cost belongs against this year's revenue.",
           BS_miss="Truck and equipment carrying values shrink again."),
  section=NULL,
  mcqs=list(
    list(q="Last year's depreciation was $4,400. This year the correct figure is $4,200. Why the change?",
      opts=c("Assets depreciate less as they age.",
             "Some equipment ($1,000 of original cost) was SOLD in E14 - you can't depreciate what you no longer own. Truck 2,400 + remaining equipment (10,000-1,000)/5 = 1,800. Total 4,200.",
             "The rate was reduced to flatter profit."),
      ans=2,
      fb=c("Not under the straight-line method - equal slices by design.",
           "Right - and notice the discipline: E14 didn't just create a loss; it quietly changed this year's depreciation too. Events ripple.",
           "Rates don't move to flatter anyone - and this one didn't move at all.")))),

list(id="A18", emoji="\U0001F3DE", label="Mary Jo's doubt 18 - 'Do I record depreciation on the LAND?'",
  hook="She's second-guessing herself. You were handed this answer as a 'preview' in Year One. Three seconds on the clock.",
  predict="NONE", dbl=TRUE,
  pfb=list(notnone="Everything depreciates except one famous holdout - and you met this exact question as a preview last session (T10). Land doesn't wear out, expire, or get used up: no limited life, nothing to allocate. It sits at $100,000, ageless."),
  win="\U0001F389 Three seconds, as promised in Year One - double points! Enjoy being the fastest hand in the room.",
  section=NULL, mcqs=list()),

list(id="A19", emoji="\u23F1", label="Mary Jo's doubt 19 - 'Interest on the land loan? I haven't paid the bank anything yet...'",
  hook="The loan is six months old; the first payment is six months away. But the meter has been running since July 1.",
  predict=c("BS","IS"), dbl=FALSE,
  pfb=list(CFS_extra="Not a rupee has gone to the bank on this loan - and yet six months of the meter has run. Expense without cash: you know this movie.",
           NONE_extra="Using $90,000 of someone's money for six months has a price, billed or not.",
           IS_miss="Six months of borrowing cost belongs to this year's income statement.",
           BS_miss="A new liability - Interest Payable - holds the unpaid meter reading."),
  section=NULL,
  mcqs=list(
    list(q="How much interest expense, and prove it.",
      opts=c("Zero - no payment, no expense.",
             "$7,200 - a full year at 8%.",
             "$3,600 = 90,000 x 8% x 6/12, with Interest Payable +3,600 holding the unpaid half-year."),
      ans=3,
      fb=c("The cash-basis ghost again. The company USED $90,000 of the bank's money for six months; that usage has a price whether or not the bill arrived.",
           "The loan is only six months old. Interest accrues with TIME: 90,000 x 8% x 6/12.",
           "Perfect. Now assemble the year's full picture: $3,000 PAID (E6, old loan) + $3,600 ACCRUED (new loan) = $6,600 of expense against only $3,000 of cash. The IS and the CFS just publicly disagreed by $3,600 - and both are right. That gap is finale fuel.")))),

list(id="A20", emoji="\U0001F4E2", label="Mary Jo's doubt 20 - 'Adjust the prepaid advertising?'",
  hook="The $5,000 campaign from E9: July 1 to next June 30. December 31 falls exactly in the middle. You see where this is going.",
  predict=c("BS","IS"), dbl=FALSE,
  pfb=list(CFS_extra="The cash left in July (E9). This adjustment moves value between asset and expense - no cash involved.",
           NONE_extra="Six months of ads have RUN - that consumption must be recognized.",
           IS_miss="Half the campaign is consumed - half the cost is this year's expense.",
           BS_miss="The Prepaid asset melts by exactly the consumed half."),
  section=NULL,
  mcqs=list(
    list(q="The year-end split of the $5,000?",
      opts=c("All $5,000 expensed - the money's gone.",
             "$2,500 expensed (July-December's ads, consumed); $2,500 stays as an asset (January-June, still coming).",
             "Nothing until the campaign finishes."),
      ans=2,
      fb=c("The MONEY went in July; the BENEFIT goes month by month. Six months have run; six are still owed to us.",
           "Exactly the calendar-of-benefit logic you stated hypothetically in Year One (T7), now with real arithmetic. Prepaids melt into expenses on schedule.",
           "Then December's profit would carry none of the cost of December's own advertising - matching would file a complaint.")))),

list(id="A21", emoji="\U0001F381", label="Mary Jo's doubt 21 - 'Adjust the deferred revenue?'",
  hook="The $10,000 deposit from E11 sits on the books as a liability. Year-end has arrived. The plants have not.",
  predict="NONE", dbl=TRUE,
  pfb=list(notnone="The plants ship in FEBRUARY - as of December 31 nothing has been earned, so the full $10,000 stays a liability. Recognizing it now would book revenue for undelivered plants - the exact sin E12 taught you to spot in press releases. Adjustments follow events, and the event hasn't happened."),
  win="\U0001F389 Fourth and final payoff - double points! The 'None' option retires with a perfect record: four appearances, four lessons.",
  section=NULL,
  mcqs=list(
    list(q="When and how does this $10,000 finally become revenue?",
      opts=c("Ratably, about $833 per month until February.",
             "In February, at delivery: liability -10,000, revenue +10,000. No cash moves that day - the cash already came, back in November.",
             "It became revenue when received, so nothing remains."),
      ans=2,
      fb=c("Nothing is being delivered monthly - there's nothing to ratify. One delivery, one moment.",
           "Complete the symmetry: receivables = revenue before cash; deferred revenue = cash before revenue. Two timing gaps, one balance sheet bridging both directions.",
           "Then the sheet would hide a real obligation to deliver $10,000 of plants. Customers would object. So would auditors.")))),

list(id="A22", emoji="\U0001F9FE", label="Mary Jo's doubt 22 - 'This year's taxes? I'll pay them next April...'",
  hook="The Year One spoiler (T11), redeemed. You answered this transaction before ever meeting it.",
  predict=c("BS","IS"), dbl=FALSE,
  pfb=list(CFS_extra="Zero cash until April. The expense doesn't wait; the payment does.",
           NONE_extra="The tax department begs to differ - an obligation exists the moment income is earned.",
           IS_miss="The expense belongs to the year that earned the income. Forever the rule.",
           BS_miss="Taxes Payable - the IOU to the department - appears."),
  section=NULL,
  mcqs=list(
    list(q="Pre-tax profit works out to $34,500. Tax expense and its balance-sheet shadow?",
      opts=c("$5,175 expense; nothing on the BS since it's unpaid.",
             "Tax expense $5,175 (15% x 34,500) AND Taxes Payable $5,175 - the expense belongs to the earning year; the payable holds the IOU until April.",
             "Zero this year; $5,175 expense next April."),
      ans=2,
      fb=c("Unpaid is exactly WHY the balance sheet must speak: a real debt exists.",
           "Right - and your free error-detector still works: if your worksheet's pre-tax figure isn't $34,500, the mistake is upstream. Tax is always the last domino.",
           "April's payment will extinguish the PAYABLE, not create the expense."))))
)

DETECTIVE <- list(
  list(id="D1", type="mcq", title="Case 1 - The banker's eyebrow (reverse engineering)",
    q=paste("Mary Jo's loan officer studies two numbers side by side: sales up 25% (400,000 to 500,000)",
            "but receivables up 45% (85,000 to 123,000). She raises an eyebrow. What is she seeing?"),
    opts=c("Good news only - more sales naturally mean more receivables.",
           "Customers are, on average, taking longer to pay (or more sales are on credit) - the company is increasingly financing its own customers, and one of them ($2,000) is already doubtful.",
           "An accounting error - the two growth rates must match."),
    ans=2,
    fb=c("SOME growth is natural; receivables growing nearly TWICE as fast as sales is not proportion, it's drift.",
         "That's the read. Profit races ahead while cash limps behind - Year One's disease, milder strain. The banker's cure: collect faster, or grow slower. (When you formally meet 'receivable days', you'll recognize this eyebrow.)",
         "No law links them; the LACK of a law is why the comparison is informative.")),
  list(id="D2", type="judge", title="Case 2 - The land's three futures (cross-statement ripple)",
    q=paste("The land deal (E2): a $100,000 asset, 90% debt-funded. Trace its echo through the NEXT five years,",
            "assuming nothing else changes. Judge each, relative to a no-purchase world:"),
    items=c("Each future year's profit", "Each future year's cash flow from operations",
            "The company's borrowing capacity for the NEXT big idea"),
    answers=c("Lower","Lower","Lower"),
    ifb=c("Interest on the land loan (up to $7,200/yr at first) hits every income statement. And the twist: land never depreciates - so debt-funded land is ALL interest and NO depreciation, the mirror image of the cash-bought truck.",
          "The interest is paid in cash, year after year. The purchase was a one-time Investing event, but its financing haunts Operating forever.",
          "With $110,000 of loans against roughly $107,000 of equity, the debt side of the boat is heavy. Every financing choice spends future flexibility. (Formally: the debt-to-equity story.)")),
  list(id="D3", type="mcq", title="Case 3 - Reconstruct the receivables (the missing link)",
    q=paste("A rival accountant has ONLY these fragments: opening receivables 85,000; credit sales 100,000;",
            "collections on account 60,000; one 2,000 receivable written down as doubtful. No balance sheet. Closing receivables?"),
    opts=c("125,000", "123,000 = 85,000 + 100,000 - 60,000 - 2,000", "145,000"),
    ans=2,
    fb=c("You've built the pile (85 + 100 - 60) but forgotten the sick customer. Doubt shrinks the pile too.",
         "And there it is - the bridge equation: opening + additions - settlements - losses = closing. EVERY balance-sheet account obeys some version of it, which is why statements can be reverse-engineered from each other. Analysts do this for a living; you just did it in one line.",
         "Check your direction on collections - money ARRIVING shrinks receivables.")),
  list(id="D4", type="judge", title="Case 4 - Window dressing at midnight (the strategic trade-off)",
    q=paste("December 30. Mary Jo, wanting the statements to impress the bank, considers paying $20,000 of",
            "accounts payable a month early. Near-term assets currently exceed near-term dues comfortably",
            "(roughly 166,000 vs 62,000). Judge each effect:"),
    items=c("Profit", "Cash flow from operations",
            "The cushion of near-term assets over near-term dues (yes - the current ratio)"),
    answers=c("Unchanged","Lower","Higher"),
    ifb=c("Paying old bills never touched profit in two years of this course, and it won't start now.",
          "$20,000 out, purely to decorate a ratio. Real cash spent on cosmetic timing.",
          "The sly arithmetic: when the cushion is already above 1, shrinking BOTH sides by 20,000 makes the ratio prettier (166/62 is about 2.7; 146/42 is about 3.5). Nothing real improved - the same company, posed better for the photo. Now you know why analysts read the CFS beside the ratios: cash flow is much harder to pose.")),
  list(id="D5", type="mcq", title="Case 5 - The accountant's bad day (error identification)",
    q=paste("A careless bookkeeper records the ENTIRE $100,000 land purchase as 'Property expense' on this",
            "year's income statement. The trial balance still balances, so nothing complains. Consequences?"),
    opts=c("None that matter - the money left either way, so the statements tell the same story.",
           "This year's ~$29,000 profit becomes a ~$70,000 LOSS; assets are understated by $100,000; and every future year looks artificially rosy. The bank might pull the loan over a loss that never happened.",
           "Only the balance sheet is wrong; profit is a matter of opinion."),
    ans=2,
    fb=c("The CASH story is similar; the PERFORMANCE story is demolished. See the correct answer.",
         "Right - a pure classification error, invisible to the balancing equation, catastrophic to meaning. 'It balances' is the BEGINNING of accounting judgment, not the end. Capitalize-vs-expense is among the most litigated lines in real reporting - WorldCom did this in reverse, $3.8 billion worth.",
         "Profit is many things, but 'expense the land' vs 'capitalize the land' is not an opinion spectrum - one violates the definitions."))
)

MYSTERY_TILES <- c(
  "$100,000 poured into the land"                          = "land",
  "Receivables grew by $38,000 - promises, not cash"       = "ar",
  "Inventory grew by $10,000 - value on the shelf"         = "inv",
  "$10,000 of loan principal repaid to the bank"           = "loan",
  "$4,200 of depreciation expense"                          = "dep",
  "$8,000 dividend declared on December 31"                 = "div",
  "$10,000 customer deposit received in November"           = "dep2")
MYSTERY_CORRECT <- c("land","ar","inv","loan")
MYSTERY_FB <- c(
  dep  = "Depreciation is non-cash - it never explains where cash WENT.",
  div  = "Declared, not paid - not a rupee has left. Next year's problem.",
  dep2 = "The deposit brought cash IN. A source, not a drain.")

BRIDGE_TILES <- c(
  "+ 4,200  Depreciation (non-cash expense)"                        = "b_dep",
  "+ 200  Loss on equipment sale (non-cash; real cash sits in Investing)" = "b_loss",
  "- 38,000  Increase in receivables (sales not yet collected)"     = "b_ar",
  "- 10,000  Increase in inventory (cash on the shelf)"             = "b_inv",
  "- 2,500  Increase in prepaid advertising"                        = "b_pre",
  "+ 10,000  Increase in accounts payable (suppliers financing us)" = "b_ap",
  "- 5,000  Decrease in wages payable (old debt settled)"           = "b_wp",
  "+ 3,600  Increase in interest payable (expense not yet paid)"    = "b_int",
  "+ 5,175  Increase in taxes payable (expense not yet paid)"       = "b_tax",
  "+ 10,000  Increase in deferred revenue (cash before earning)"    = "b_def",
  "+ 2,000  Bad debt expense add-back"                              = "b_bad",
  "+ 8,000  Increase in dividend payable"                           = "b_div",
  "- 100,000  Purchase of land"                                     = "b_land")
BRIDGE_CORRECT <- c("b_dep","b_loss","b_ar","b_inv","b_pre","b_ap","b_wp","b_int","b_tax","b_def")
BRIDGE_FB <- c(
  b_bad = "Sneaky one: normally bad debts ARE added back - but in OUR worksheet the $2,000 was credited straight to receivables, so the -38,000 receivables change already contains it. Adding it again double-counts. (The official teaching note trips on exactly this - ask your professor.)",
  b_div = "The dividend moved NO cash and is not an operating item - it belongs to next year's Financing section. (The printed solution debates this one; your professor has opinions.)",
  b_land = "A real cash outflow - but an INVESTING one. The bridge rebuilds only the Operating section.")

# ------------------------- ITEM SEQUENCE -------------------------
ITEMS <- list()
for (i in seq_along(TXNS)) ITEMS[[length(ITEMS)+1]] <- list(type="txn", i=i)
for (j in seq_along(DETECTIVE)) ITEMS[[length(ITEMS)+1]] <- list(type="det", j=j)
ITEMS[[length(ITEMS)+1]] <- list(type="mystery")
ITEMS[[length(ITEMS)+1]] <- list(type="bridge")
ITEMS[[length(ITEMS)+1]] <- list(type="done")
N_ITEMS <- length(ITEMS)

# ------------------------------ UI -----------------------------------
ui <- fluidPage(
  tags$head(tags$style(HTML("
    body { background:#f5f2e8; font-family: Georgia, 'Times New Roman', serif;
           max-width: 900px; margin:auto; padding-bottom:40px;}
    .topbar { background:#2e5d34; color:#fff; border-radius:0 0 14px 14px;
              padding:14px 22px; display:flex; justify-content:space-between;
              align-items:center; flex-wrap:wrap;}
    .topbar h2 { margin:0; font-size:21px; color:#fff;}
    .chip { background:#e8a020; color:#2e2a1f; font-weight:bold; border-radius:20px;
            padding:5px 14px; font-size:14px; }
    .progresswrap { background:#dcd6c3; border-radius:8px; height:12px; margin:8px 0 16px;}
    .progressbar { background:linear-gradient(90deg,#6aa84f,#2e5d34); height:12px; border-radius:8px;}
    .card { background:#fffdf7; border:1px solid #e0dac6; border-radius:14px;
            padding:24px 28px; box-shadow:0 3px 10px rgba(60,50,20,.08); margin-top:10px;}
    .hook { background:#eef4e6; border-left:5px solid #6aa84f; padding:12px 16px;
            border-radius:0 8px 8px 0; font-style:italic; margin:10px 0 18px; font-size:16px;}
    .txnhead { font-size:19px; font-weight:bold; color:#2e5d34; }
    .stagechip { display:inline-block; background:#2e5d34; color:#fff; border-radius:14px;
                 padding:2px 12px; font-size:12px; letter-spacing:1px; margin-bottom:8px;}
    .good { background:#e3f0dc; border-left:5px solid #2e7d32; padding:12px 16px;
            border-radius:0 8px 8px 0; margin:12px 0;}
    .nudge { background:#fdf3dc; border-left:5px solid #e8a020; padding:12px 16px;
             border-radius:0 8px 8px 0; margin:12px 0;}
    .miss { background:#fbe9e7; border-left:5px solid #c0522d; padding:12px 16px;
            border-radius:0 8px 8px 0; margin:12px 0;}
    .warnband { background:#c0522d; color:#fff; font-weight:bold; text-align:center;
                border-radius:8px; padding:10px 14px; margin-bottom:12px;}
    .cert { border:3px double #2e5d34; border-radius:14px; padding:22px 26px;
            background:#fffef9; }
    .cert h2 { color:#2e5d34; margin-top:0;}
    .bigscore { font-size:34px; font-weight:bold; }
    .pass { color:#2e7d32; } .fail { color:#c0522d; }
    .btn-primary { background:#2e5d34 !important; border-color:#2e5d34 !important;}
    .btn-success { background:#e8a020 !important; border-color:#e8a020 !important;
                   color:#2e2a1f !important; font-weight:bold;}
    .checkbox label, .radio label { font-size:15px; line-height:1.45; margin-bottom:6px;}
    .idbox { background:#f4f0e2; border-radius:10px; padding:12px 16px; margin:8px 0;}
    h3,h4 { color:#2e5d34; }
  "))),
  uiOutput("topbar"),
  uiOutput("progress"),
  uiOutput("main")
)

# ------------------------------ SERVER --------------------------------
server <- function(input, output, session) {

  rv <- reactiveValues(state="intro", mode=NULL, ids=list(),
                       item=1, stage="predict", mcq_i=1,
                       attempts=0, feedback=NULL, fbclass="nudge", solved=FALSE,
                       score=0, streak=0, best_streak=0, finished_at=NULL)

  output$topbar <- renderUI({
    div(class="topbar",
        h2(paste0("\U0001F33B The Garden Spot - Year Two  (", EXERCISE_TAG, ")")),
        if (rv$state == "run")
          div(span(class="chip", paste0(rv$score, " pts · ",
                round(100*rv$score/MAX_POINTS), "% · target ", TARGET_PCT, "%")),
              if (rv$streak >= 2) span(style="color:#ffd9a0;font-weight:bold;",
                paste0("  \U0001F525 ", rv$streak))))
  })

  output$progress <- renderUI({
    if (rv$state != "run") return(NULL)
    div(class="progresswrap",
        div(class="progressbar",
            style=paste0("width:", round(100*(rv$item-1)/(N_ITEMS-1)), "%")))
  })

  cur <- reactive(ITEMS[[rv$item]])

  advance <- function() {
    rv$item <- min(rv$item + 1, N_ITEMS)
    rv$stage <- "predict"; rv$mcq_i <- 1
    rv$attempts <- 0; rv$feedback <- NULL; rv$solved <- FALSE
    if (ITEMS[[rv$item]]$type == "done" && is.null(rv$finished_at))
      rv$finished_at <- Sys.time()
  }
  set_fb <- function(text, class) { rv$feedback <- text; rv$fbclass <- class }

  output$fbbox <- renderUI({
    if (is.null(rv$feedback)) return(NULL)
    div(class=rv$fbclass, HTML(rv$feedback))
  })

  guard <- function(expr) tryCatch(expr, error=function(e)
    set_fb(paste0("A small hiccup occurred (", conditionMessage(e),
                  "). Nothing is lost - please press the button again."), "nudge"))

  # ---------------- UI builders ----------------
  id_fields <- function(prefix, title) {
    div(class="idbox", h4(title),
      fluidRow(
        column(6, textInput(paste0(prefix,"_roll"), "Roll No:")),
        column(6, textInput(paste0(prefix,"_name"), "Full name:"))),
      fluidRow(
        column(6, selectInput(paste0(prefix,"_sec"), "Section:",
                              choices=c("A","B","C"))),
        column(6, textInput(paste0(prefix,"_email"), "Email:"))))
  }

  intro_ui <- function() div(class="card",
    h3("Welcome to Year Two \U0001F44B"),
    p("You built Year Two's worksheets and statements in class today. Now the questions -",
      "and this year, they bite back."),
    tags$ul(
      tags$li(strong("What's ahead: "), "22 events and adjustments, a 5-case Detective Round,",
              "and a two-part finale. About 55 questions."),
      tags$li(strong("Points (max ", MAX_POINTS, "): "),
              "statement-prediction 10 (5 on 2nd try) - but the four 'nothing gets recorded'",
              "payoffs score DOUBLE; CFS section 5; concept questions 10, single attempt;",
              "Detective cases 15 each; judgments 5 per part; the two finale puzzles 20 + 30."),
      tags$li(strong("Target: ", TARGET_PCT, "% = ", TARGET_PTS, " points."),
              " Below target? Play again - a fresh round starts from zero, and your BEST",
              " screenshot is the one you submit."),
      tags$li(strong("\U0001F4F8 Your final screen is your submission."),
              " You will screenshot the score certificate at the end - so do NOT close or",
              " refresh this app mid-way (a refresh wipes everything)."),
      tags$li(em("Privacy: your details below are used ONLY to print on your score",
              " certificate. Nothing you enter or answer is saved or sent anywhere."))),
    radioButtons("mode", "How are you playing today?",
                 choices=c("Individual"="solo", "Pair"="pair"), inline=TRUE),
    uiOutput("id_forms"),
    actionButton("start", "Let's dig in \U0001F331", class="btn-primary"),
    uiOutput("intro_msg"))

  output$id_forms <- renderUI({
    if (identical(input$mode, "pair"))
      tagList(id_fields("s1", "Student 1"), id_fields("s2", "Student 2"))
    else id_fields("s1", "Your details")
  })

  txn_ui <- function(t) {
    div(class="card",
      span(class="stagechip", paste0("ITEM ", rv$item, " OF ", length(TXNS),
                                     if (isTRUE(t$dbl)) "  ·  \u2B50 DOUBLE POINTS POSSIBLE" else "")),
      div(class="txnhead", paste(t$emoji, t$label)),
      div(class="hook", t$hook),
      if (rv$stage == "predict") tagList(
        p(strong("Re-read this event in your printed case."),
          "Which statements does it - just this one - affect?"),
        checkboxGroupInput("pred", NULL, choices=STMT_CHOICES),
        actionButton("pred_go", "Lock it in", class="btn-primary"),
        uiOutput("fbbox"),
        if (rv$solved) actionButton("pred_next", "Onward \u2192", class="btn-success")
      ) else if (rv$stage == "section") tagList(
        p(strong("The Cash Flow Statement is affected - correct. Which section?"),
          if (!is.null(t$section_note)) em(paste0(" (", t$section_note, ")"))),
        checkboxGroupInput("sect", NULL, choices=SECT_CHOICES),
        actionButton("sect_go", "Lock it in", class="btn-primary"),
        uiOutput("fbbox"),
        if (rv$solved) actionButton("sect_next", "Onward \u2192", class="btn-success")
      ) else mcq_block(t$mcqs[[rv$mcq_i]],
                       sprintf("Question %d of %d on this event", rv$mcq_i, length(t$mcqs)))
    )
  }

  mcq_block <- function(m, subtitle) {
    tagList(p(em(subtitle)), p(strong(m$q)),
      radioButtons("mcq", NULL, choices=setNames(seq_along(m$opts), m$opts),
                   selected=character(0), width="100%"),
      actionButton("mcq_go", "Lock it in", class="btn-primary"),
      uiOutput("fbbox"),
      if (rv$solved) actionButton("mcq_next", "Onward \u2192", class="btn-success"))
  }

  det_ui <- function(d) {
    div(class="card",
      span(class="stagechip", "\U0001F50E DETECTIVE ROUND · 15 pts"),
      div(class="txnhead", d$title),
      if (d$type == "mcq") tagList(p(strong(d$q)),
        radioButtons("det_mcq", NULL, choices=setNames(seq_along(d$opts), d$opts),
                     selected=character(0), width="100%"),
        actionButton("det_go", "Crack it", class="btn-primary"),
        uiOutput("fbbox"),
        if (rv$solved) actionButton("det_next", "Next case \u2192", class="btn-success")
      ) else tagList(p(strong(d$q)),
        lapply(seq_along(d$items), function(k)
          radioButtons(paste0("dj", k), d$items[k],
                       choices=c("Higher","Lower","Unchanged"),
                       selected=character(0), inline=TRUE)),
        actionButton("dj_go", "Crack it", class="btn-primary"),
        uiOutput("fbbox"),
        if (rv$solved) actionButton("det_next", "Next case \u2192", class="btn-success")))
  }

  warn_band <- div(class="warnband",
    "\U0001F4F8 Almost done - do NOT close or refresh. Your final screen is your submission: you'll screenshot it.")

  mystery_ui <- function() div(class="card", warn_band,
    span(class="stagechip", "FINALE · PART 1"),
    div(class="txnhead", "\U0001F50E The Inverse Mystery"),
    div(class="hook", paste(
      "Last year: profit but no cash. This year: profit $29,325 PLUS $110,000 of new money",
      "raised (Lawrence's $20,000 + the $90,000 land loan). And yet cash grew by only $7,610",
      "(3,010 to 10,610). Mary Jo, again: 'WHERE did it all GO?'")),
    p(strong("Select EVERY genuine cash drain - and nothing that isn't one:")),
    checkboxGroupInput("myst", NULL, choices=MYSTERY_TILES, width="100%"),
    actionButton("myst_go", "Crack the case", class="btn-primary"),
    uiOutput("fbbox"),
    if (rv$solved) actionButton("myst_next", "To the final puzzle \u2192", class="btn-success"))

  bridge_ui <- function() div(class="card", warn_band,
    span(class="stagechip", "FINALE · PART 2 · 30 pts"),
    div(class="txnhead", "\U0001F309 The Indirect Bridge"),
    div(class="hook", paste(
      "Every published annual report starts its cash flow statement from PROFIT, not from",
      "cash receipts. Your mission: rebuild operating cash flow ($7,000) starting from net",
      "income ($29,325). Select every adjustment that belongs on the bridge - and reject the",
      "impostors. Signs are shown; trust your worksheet.")),
    checkboxGroupInput("brg", NULL, choices=BRIDGE_TILES, width="100%"),
    actionButton("brg_go", "Build the bridge", class="btn-primary"),
    uiOutput("fbbox"),
    if (rv$solved) actionButton("brg_next", "Claim your certificate \u2192", class="btn-success"))

  done_ui <- function() {
    pct <- round(100*rv$score/MAX_POINTS)
    passed <- rv$score >= TARGET_PTS
    who <- rv$ids
    subj <- if (identical(rv$mode, "pair"))
      paste0(EXERCISE_TAG, " | ", who$s1_sec, " | ", who$s1_roll, "+", who$s2_roll)
      else paste0(EXERCISE_TAG, " | ", who$s1_sec, " | ", who$s1_roll)
    div(class="card",
      div(class="warnband", "\U0001F4F8 SCREENSHOT THIS SCREEN NOW - it is your submission."),
      div(class="cert",
        h2(paste0("The Garden Spot - Year Two · Score Certificate (", EXERCISE_TAG, ")")),
        p(strong("Mode: "), ifelse(identical(rv$mode,"pair"), "Pair", "Individual")),
        p(strong("Student 1: "), who$s1_name, " · Roll ", who$s1_roll,
          " · Section ", who$s1_sec, " · ", who$s1_email),
        if (identical(rv$mode, "pair"))
          p(strong("Student 2: "), who$s2_name, " · Roll ", who$s2_roll,
            " · Section ", who$s2_sec, " · ", who$s2_email),
        p(span(class=paste("bigscore", ifelse(passed, "pass", "fail")),
               paste0(rv$score, " / ", MAX_POINTS, "  (", pct, "%)"))),
        p(strong(ifelse(passed,
          "\u2705 Target met (80%). Screenshot and submit this certificate.",
          paste0("\U0001F331 Below the ", TARGET_PCT, "% target. Replay the app - a fresh round",
                 " starts from zero, and your BEST certificate is the one you submit.")))),
        p("Best streak: ", rv$best_streak,
          " · Completed: ", format(rv$finished_at %||% Sys.time(), "%d %b %Y, %H:%M:%S")),
        hr(),
        h4("How to submit"),
        tags$ol(
          tags$li("Save this screenshot on your device."),
          tags$li(paste0("Email it to ", SUBMIT_EMAIL, " ", DEADLINE_TXT, ".")),
          tags$li(paste0("Subject line, exactly: ", subj)),
          if (identical(rv$mode, "pair"))
            tags$li("Pairs: BOTH partners submit this same screenshot from their own email."))),
      br(),
      p(em("Every seed from Year One flowered here. Next stop: a real company's annual report -",
           "where you'll recognize every line.")))
  }

  output$main <- renderUI({
    if (rv$state == "intro") return(intro_ui())
    s <- cur()
    switch(s$type,
      txn = txn_ui(TXNS[[s$i]]),
      det = det_ui(DETECTIVE[[s$j]]),
      mystery = mystery_ui(),
      bridge = bridge_ui(),
      done = done_ui())
  })

  # ---------------- events ----------------
  output$intro_msg <- renderUI(NULL)
  observeEvent(input$start, guard({
    need1 <- c("s1_roll","s1_name","s1_email")
    fields <- if (identical(input$mode,"pair")) c(need1, "s2_roll","s2_name","s2_email") else need1
    vals <- lapply(fields, function(f) trimws(input[[f]] %||% ""))
    names(vals) <- fields
    if (any(!nzchar(unlist(vals)))) {
      output$intro_msg <- renderUI(p(style="color:#c0522d",
        "Please fill every field - the certificate needs them all.")); return()
    }
    emails <- unlist(vals[grepl("email", names(vals))])
    if (any(!grepl("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", emails))) {
      output$intro_msg <- renderUI(p(style="color:#c0522d",
        "One of the email addresses doesn't look right.")); return()
    }
    if (identical(input$mode,"pair") && identical(toupper(vals$s1_roll), toupper(vals$s2_roll))) {
      output$intro_msg <- renderUI(p(style="color:#c0522d",
        "Two students, two different roll numbers, surely.")); return()
    }
    rv$ids <- c(vals, list(s1_sec=input$s1_sec %||% "A",
                           s2_sec=input$s2_sec %||% (input$s1_sec %||% "A")))
    rv$mode <- input$mode
    rv$state <- "run"
  }))

  observeEvent(input$pred_go, guard({
    s <- cur(); t <- TXNS[[s$i]]
    picked <- input$pred %||% character(0)
    if (!length(picked)) { set_fb("Tick at least one option first.", "nudge"); return() }
    rv$attempts <- rv$attempts + 1
    ok <- setequal(picked, t$predict)
    base <- if (isTRUE(t$dbl)) 20 else 10
    if (ok) {
      rv$solved <- TRUE
      pts <- ifelse(rv$attempts == 1, base, base/2)
      rv$score <- rv$score + pts
      if (rv$attempts == 1) { rv$streak <- rv$streak + 1
        rv$best_streak <- max(rv$best_streak, rv$streak) } else rv$streak <- 0
      win <- t$win %||% paste0("<b>Correct: ",
        paste(names(STMT_CHOICES)[match(t$predict, STMT_CHOICES)], collapse=" + "), ".</b>")
      set_fb(paste0(win, " +", pts, " pts."), "good")
    } else {
      rv$streak <- 0
      msgs <- character(0)
      if (identical(t$predict, "NONE")) {
        msgs <- t$pfb$notnone
      } else {
        for (st in c("BS","IS","CFS","NONE")) {
          ek <- paste0(st, "_extra"); mk <- paste0(st, "_miss")
          if (st %in% picked && !(st %in% t$predict) && !is.null(t$pfb[[ek]]))
            msgs <- c(msgs, t$pfb[[ek]])
          if (!(st %in% picked) && (st %in% t$predict) && !is.null(t$pfb[[mk]]))
            msgs <- c(msgs, t$pfb[[mk]])
        }
      }
      if (!length(msgs)) msgs <- "Re-read the event: was anything earned? consumed? did cash move?"
      if (rv$attempts >= 2) {
        rv$solved <- TRUE
        set_fb(paste0("The answer: <b>",
          paste(names(STMT_CHOICES)[match(t$predict, STMT_CHOICES)], collapse=" + "),
          "</b>.<br/>", paste(msgs, collapse="<br/>")), "miss")
      } else set_fb(paste0("Not quite - one more go.<br/>",
                           paste(msgs, collapse="<br/>")), "nudge")
    }
  }))
  observeEvent(input$pred_next, guard({
    t <- TXNS[[cur()$i]]
    if (!is.null(t$section)) { rv$stage <- "section" }
    else if (length(t$mcqs)) { rv$stage <- "mcq" }
    else { advance(); return() }
    rv$attempts <- 0; rv$feedback <- NULL; rv$solved <- FALSE
  }))

  observeEvent(input$sect_go, guard({
    t <- TXNS[[cur()$i]]
    picked <- input$sect %||% character(0)
    if (!length(picked)) { set_fb("Pick at least one section.", "nudge"); return() }
    rv$attempts <- rv$attempts + 1
    ok <- setequal(picked, t$section)
    if (ok) {
      rv$solved <- TRUE; rv$score <- rv$score + 5
      set_fb(t$section_win %||% paste0("<b>",
        paste(names(SECT_CHOICES)[match(t$section, SECT_CHOICES)], collapse=" + "),
        "</b> it is. +5 pts."), "good")
    } else {
      msgs <- character(0)
      if (length(t$section) > 1) {
        if (setequal(picked, t$section[1]) && !is.null(t$sfb[[paste0(t$section[1],"_only")]]))
          msgs <- t$sfb[[paste0(t$section[1],"_only")]]
        if (setequal(picked, t$section[2]) && !is.null(t$sfb[[paste0(t$section[2],"_only")]]))
          msgs <- t$sfb[[paste0(t$section[2],"_only")]]
        extra <- setdiff(picked, t$section)
        for (s in extra) if (!is.null(t$sfb[[s]])) msgs <- c(msgs, t$sfb[[s]])
      } else {
        for (s in picked) if (!is.null(t$sfb[[s]])) msgs <- c(msgs, t$sfb[[s]])
      }
      if (!length(msgs)) msgs <- "Where did money come from or go - financiers, long-lived assets, or the daily business?"
      if (rv$attempts >= 2) {
        rv$solved <- TRUE
        set_fb(paste0("The answer: <b>",
          paste(names(SECT_CHOICES)[match(t$section, SECT_CHOICES)], collapse=" + "),
          "</b>.<br/>", paste(msgs, collapse="<br/>")), "miss")
      } else set_fb(paste0("Not quite.<br/>", paste(msgs, collapse="<br/>")), "nudge")
    }
  }))
  observeEvent(input$sect_next, guard({
    t <- TXNS[[cur()$i]]
    if (length(t$mcqs)) { rv$stage <- "mcq"; rv$attempts <- 0
      rv$feedback <- NULL; rv$solved <- FALSE } else advance()
  }))

  observeEvent(input$mcq_go, guard({
    t <- TXNS[[cur()$i]]; m <- t$mcqs[[rv$mcq_i]]
    req(length(input$mcq) == 1)
    pick <- as.integer(input$mcq)
    ok <- pick == m$ans
    rv$solved <- TRUE
    if (ok) { rv$score <- rv$score + 10
      set_fb(paste0("<b>Yes!</b> ", m$fb[pick], " <i>+10 pts.</i>"), "good")
    } else set_fb(paste0("<b>Hmm - here's why that one tempts people:</b> ", m$fb[pick],
      "<br/><br/><b>The answer:</b> '", m$opts[m$ans], "'<br/>", m$fb[m$ans]), "miss")
  }))
  observeEvent(input$mcq_next, guard({
    t <- TXNS[[cur()$i]]
    if (rv$mcq_i < length(t$mcqs)) {
      rv$mcq_i <- rv$mcq_i + 1; rv$attempts <- 0
      rv$feedback <- NULL; rv$solved <- FALSE
    } else advance()
  }))

  observeEvent(input$det_go, guard({
    d <- DETECTIVE[[cur()$j]]
    req(length(input$det_mcq) == 1)
    pick <- as.integer(input$det_mcq)
    ok <- pick == d$ans
    rv$solved <- TRUE
    if (ok) { rv$score <- rv$score + 15
      set_fb(paste0("<b>Case cracked!</b> ", d$fb[pick], " <i>+15 pts.</i>"), "good")
    } else set_fb(paste0("<b>A reasonable suspect, but:</b> ", d$fb[pick],
      "<br/><br/><b>The real culprit:</b> '", d$opts[d$ans], "'<br/>", d$fb[d$ans]), "miss")
  }))
  observeEvent(input$dj_go, guard({
    d <- DETECTIVE[[cur()$j]]
    picks <- vapply(seq_along(d$items), function(k) input[[paste0("dj",k)]] %||% "", "")
    if (any(!nzchar(picks))) { set_fb("Judge all three before cracking.", "nudge"); return() }
    n <- sum(picks == d$answers)
    rv$solved <- TRUE
    rv$score <- rv$score + 5*n
    lines <- vapply(seq_along(d$items), function(k) paste0(
      ifelse(picks[k]==d$answers[k], "\u2705 ", "\u274C "),
      "<b>", d$items[k], " \u2192 ", d$answers[k], ".</b> ", d$ifb[k]), "")
    set_fb(paste0("<b>", n, " of 3.</b><br/>", paste(lines, collapse="<br/>")),
           ifelse(n==3, "good", "miss"))
  }))
  observeEvent(input$det_next, advance())

  observeEvent(input$myst_go, guard({
    picked <- input$myst %||% character(0)
    if (!length(picked)) { set_fb("A detective must accuse SOMEONE.", "nudge"); return() }
    rv$attempts <- rv$attempts + 1
    ok <- setequal(picked, MYSTERY_CORRECT)
    if (ok) {
      rv$solved <- TRUE
      pts <- ifelse(rv$attempts == 1, 20, 10); rv$score <- rv$score + pts
      set_fb(paste0("<b>Case closed. +", pts, " pts.</b> The land swallowed $100,000;",
        " receivables trapped $38,000 more; inventory $10,000; the bank took back $10,000.",
        " Even a fat profit and fresh financing can vanish into ASSETS.",
        " The company isn't poorer - its wealth just stopped being spendable."), "good")
    } else {
      wrongs <- intersect(picked, names(MYSTERY_FB))
      msg <- if (length(wrongs)) paste(MYSTERY_FB[wrongs], collapse="<br/>")
             else "You're missing at least one genuine drain. What was the year's biggest purchase?"
      if (rv$attempts >= 3) {
        rv$solved <- TRUE
        set_fb(paste0("The four culprits: land $100,000; receivables +$38,000;",
          " inventory +$10,000; principal repaid $10,000.<br/>", msg), "miss")
      } else set_fb(msg, "nudge")
    }
  }))
  observeEvent(input$myst_next, advance())

  observeEvent(input$brg_go, guard({
    picked <- input$brg %||% character(0)
    if (!length(picked)) { set_fb("The bridge needs planks. Select the adjustments.", "nudge"); return() }
    rv$attempts <- rv$attempts + 1
    ok <- setequal(picked, BRIDGE_CORRECT)
    if (ok) {
      rv$solved <- TRUE
      pts <- ifelse(rv$attempts == 1, 30, 15); rv$score <- rv$score + pts
      set_fb(paste0("<b>The bridge stands! +", pts, " pts.</b> 29,325 + 4,200 + 200",
        " - 38,000 - 10,000 - 2,500 + 10,000 - 5,000 + 3,600 + 5,175 + 10,000 = <b>7,000</b> -",
        " exactly the CFO your worksheet computed the direct way. Two roads, one truth.",
        " You can now read ANY published cash flow statement - they all start here."), "good")
    } else {
      wrongs <- intersect(picked, names(BRIDGE_FB))
      missing <- length(setdiff(BRIDGE_CORRECT, picked))
      msg <- character(0)
      if (length(wrongs)) msg <- c(msg, paste(BRIDGE_FB[wrongs], collapse="<br/>"))
      if (missing > 0) msg <- c(msg, paste0("And ", missing,
        " genuine plank(s) still missing - every working-capital change and non-cash expense belongs."))
      if (rv$attempts >= 3) {
        rv$solved <- TRUE
        set_fb(paste0("The ten planks: depreciation, loss on sale, and the eight",
          " working-capital changes (receivables, inventory, prepaid, payables, wages payable,",
          " interest payable, taxes payable, deferred revenue).<br/>",
          paste(msg, collapse="<br/>")), "miss")
      } else set_fb(paste(msg, collapse="<br/>"), "nudge")
    }
  }))
  observeEvent(input$brg_next, advance())
}

shinyApp(ui, server)
