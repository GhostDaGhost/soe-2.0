-- ProcessTaxes(transactionData, totalPrice, item)
local ready = false
local taxRates = {}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print("Getting latest tax rates...")

    local result = exports["soe-nexus"]:PerformAPIRequest("/api/tax/getrates", json.encode({}), true).data

    for i, rateInfo in pairs (result) do
        -- print(i, json.encode(rateInfo))
        taxRates[rateInfo.AppliesToType] = {}
        taxRates[rateInfo.AppliesToType].label = rateInfo.Label
        taxRates[rateInfo.AppliesToType].rate = rateInfo.RatePercentage
        taxRates[rateInfo.AppliesToType].ratetype = "percent"
    end

    -- Debug print
    -- print("Current tax rates:")
    -- for type, rate in pairs (taxRates) do
    --     print(type, json.encode(rate))
    -- end

    ready = true
end)  

function ProcessTaxes(transactionData, total, item, storeType)
    if not ready then return false end

    -- print("transactionData: ", json.encode(transactionData))
    -- print("total: ", total)
    -- print("item: ", json.encode(item))
    -- print("storeType: ", storeType)

    -- Check for a tax type for the specific store type
    if taxRates[storeType] then
        -- print(("Charging specific tax [%s percent] for %s (x%s) in store type [%s]"):format(taxRates[storeType].rate, item.item, item.amt, storeType))
        return { rate = taxRates[storeType].rate, type = taxRates["standard_tax"].ratetype }
    elseif taxRates["standard_tax"] then -- Attempt to apply standard tax as no specific rate was found
        -- print(("Charging standard tax [%s percent] for %s (x%s) in store type [%s]"):format(taxRates["standard_tax"].rate, item.item, item.amt, storeType))
        return { rate = taxRates["standard_tax"].rate, type = taxRates["standard_tax"].ratetype }
    end

    -- Couldn't find specific or default tax rate, return false (force-quit transaction)
    return false
end

function PayTaxForCashTransaction(total, tax)
    -- print("PayTaxForCashTransaction", total, json.encode(tax))

    local args

    if tax.type == "percent" then
        args = ("total=%s&taxpercent=%s"):format(total, tax.rate)
    else
        args = ("total=%s&taxamount=%s"):format(total, tax.rate)
    end

    local result = exports["soe-nexus"]:PerformAPIRequest("/api/tax/cashtransaction", args, true)

    -- print(result.status)

    return result.status
end