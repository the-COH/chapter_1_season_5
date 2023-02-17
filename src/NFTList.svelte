<script lang="ts">

let open :boolean = true;

function closeModal() {
    open = false;
}

function openModal() {
    open = true;
}

</script>

{#if open}
<div id="modal-container" class="modal">
    <div class="modal-content">
        <span on:click="{closeModal}" class="close-button" on:keypress="{closeModal}">×</span>

        <div class="gas-modal">
          <label style="display:flex; justify-content:center; text-align:center; margin:0px !important; padding:0px !important; font-size:25px;" for="Amount">New Gas: </label>
          <button on:click="{closeModal}">good</button>
        </div>

    </div>
</div>
{/if}




<style>

/************** Modal ********************************************************************/

      /* The Modal (background) */
      .modal {
        display: none; /* Hidden by default */
        position: fixed; /* Stay in place */
        z-index: 1; /* Sit on top */
        padding-top: 50px; /* Location of the box */
        left: 0;
        top: 0;
        width: 100%; /* Full width */
        height: 100%; /* Full height */
        overflow: auto; /* Enable scroll if needed */
        background-color: rgb(0,0,0); /* Fallback color */
        background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
      }

      /* Modal Content */
      .modal-content {
        background-color: #75f8dc;
        margin: auto;
        padding: 10px 15px;
        border: 1px solid #888;
        width: 80%;
        border-radius: 20px;
      }

      /* The Close Button */
      .close-button {
        color: #000000;
        float: right;
        font-size: 30px;
        font-weight: 700;
        width: 35px;
        height: 33px;
        text-align: center;
        border: 2px solid black;
        background-color: red;
      }

      .close-button:hover,
      .close-button:focus {
        background-color: rgb(223, 0, 0);
        cursor: pointer;
      }

      .gas-modal {
        display: grid;
        justify-items: center;
      }

      .gas-modal > input {
        margin-top: 10px;
      }

/************** Modal ********************************************************************/
</style>