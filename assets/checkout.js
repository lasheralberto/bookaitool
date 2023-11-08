// Set your publishable key: remember to change this to your live publishable key in production
// See your keys here: https://dashboard.stripe.com/apikeys
const stripe = Stripe('pk_test_a5UTLjkFh4BO6GZlTakE4EpN');
const options = {
    clientSecret: '{{sk_test_51DVNrAFS1UGHVPAZlEXkSjwhuKX4cm1KdH3FyY0NDcrSy8u80j6ElxlJmDpjfZ2b2ifOCwpH853vBS6dIKaxZoDV001Sg7qudZ}}',
    // Fully customizable with appearance API.
    appearance: { /*...*/ },
};

// Set up Stripe.js and Elements to use in checkout form, passing the client secret obtained in a previous step
const elements = stripe.elements(options);

// Create and mount the Payment Element
const paymentElement = elements.create('payment');
paymentElement.mount('#payment-element');