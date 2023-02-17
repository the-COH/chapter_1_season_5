<script lang="ts">
    import Header from './Header.svelte'
	// import Footer from './Footer.svelte'
	import './styles.css'
</script>

<div class="app">

	<Header />

	<main>
		<slot />
	</main>

	<!-- <Footer /> -->

</div>





<style>

	.app {
        background: #13171a;
        background-color: black;
        background-color: aliceblue;
        background-color: #041225;
        font-family: Arial, Helvetica, sans-serif;
        display: grid;
        justify-items: center;
        align-items: center;
        color: white;
        color: #06fc99;
	}


</style>
