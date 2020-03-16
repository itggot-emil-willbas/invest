function doMath()
{
    console.log("Change was made!")
    // Capture the entered values of two input boxes
    var aprice = document.getElementById('new_aprice').value;
    var amount = document.getElementById('new_amount').value;

    console.log(`Aprice: ${aprice} and amount ${amount}`);


    // Add them together and display
    var sum = (aprice) * parseInt(amount);
    document.getElementById('new_total').value = (sum);
}

document.addEventListener("change",doMath)