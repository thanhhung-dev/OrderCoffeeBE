package com.example.OrderCoffeeBE.Controller;

import com.example.OrderCoffeeBE.Model.Tables;
import com.example.OrderCoffeeBE.Service.impl.TableServiceImpl;
import com.example.OrderCoffeeBE.Util.Anotation.ApiMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/table")
@RequiredArgsConstructor
public class TableController {
    private final TableServiceImpl tableService;
    @GetMapping
    @ApiMessage("Fetch Table")
    public ResponseEntity<List<Tables>> getTables() {
        return ResponseEntity.status(HttpStatus.OK).body(this.tableService.findAll());
    }
    @GetMapping("/{id}")
    @ApiMessage("Fetch By Id Table")
    public ResponseEntity<Tables> getTableById(@PathVariable int id) {
        return ResponseEntity.status(HttpStatus.OK).body(this.tableService.findById(id));
    }
    @ApiMessage("Create a Table")
    public ResponseEntity<Tables> addTable(@RequestBody Tables tables) {
        Tables newTables = this.tableService.createTable(tables);
        return ResponseEntity.status(HttpStatus.CREATED).body(newTables);
    }
    @PatchMapping()
    @ApiMessage("Update a Table")
    public ResponseEntity<Tables> updateTable(@PathVariable int id, @RequestBody Tables tables) {
        tables.setId(id);
        Tables updateTables = this.tableService.updateTable(tables);
        return ResponseEntity.status(HttpStatus.OK).body(updateTables);
    }
    @ApiMessage("Delete a Table")
    @DeleteMapping()
    public ResponseEntity<Tables> deleteTable(@RequestParam int id) {
        this.tableService.deleteTable(id);
        return ResponseEntity.ok(null);
    }
}
